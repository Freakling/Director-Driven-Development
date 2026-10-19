#!/usr/bin/env python3
"""tools/usage.py: what a Claude Code project cost, from its transcripts, at API prices.

Reads ~/.claude/projects/<project>/**/*.jsonl (main sessions and subagents), takes one usage
entry per message (the transcript logs a message once per content block; the cache and input
counts repeat, the output count grows, so the largest value of each field is the message's),
and prices it at the pay-as-you-go rates below. Nothing here is what a subscription billed:
it is the API-equivalent, a measure of the work's size.

    python tools/usage.py                      every project under ~/.claude/projects
    python tools/usage.py <project-folder>     one project (the folder name, or a substring)
    python tools/usage.py --weekly             API-equivalent per week across every project

Per project: the total, the share by token kind, the share of the orchestrating session, the
director's hours at the keyboard (every wait of 30 minutes or less that ended with a message
from the director) and the agent's hours on its own, and three counterfactuals: nothing cached,
every call on Opus, every call on Sonnet. Update PRICES when the price list changes, and date
every figure you quote.
"""
import collections
import datetime
import glob
import json
import os
import sys

# Per million tokens: input, output, cache read, cache write (5-minute). claude.com/pricing, 2026-10-19.
PRICES = {
    "claude-fable-5-1": (10, 50, 0.25, 12.5),
    "claude-opus-5-5": (4, 20, 0.20, 5),
    "claude-sonnet-5-5": (2, 10, 0.10, 2.5),
    "claude-haiku-5-5": (0.10, 0.50, 0.01, 0.125),
    "claude-haiku-5-5-big": (0.50, 2.50, 0.05, 0.625),  # prompts over 100K tokens
    "claude-haiku-4-5-20251001": (1, 5, 0.10, 1.25),
    "claude-sonnet-5": (3, 15, 0.30, 3.75),
}
ROOT = os.path.expanduser("~/.claude/projects")


def price(model, prompt_tokens):
    if model == "claude-haiku-5-5" and prompt_tokens > 100_000:
        model = "claude-haiku-5-5-big"
    return PRICES.get(model)


def load(project_dir):
    """One row per assistant message: (role, model, timestamp, [input, output, cache write, cache read]).
    Also the main sessions' events for the hour counts."""
    msgs = {}
    events = []
    for f in glob.glob(os.path.join(project_dir, "**", "*.jsonl"), recursive=True):
        sub = "subagent" in f or "/tasks/" in f.replace("\\", "/")
        role = "sub" if sub else "main"
        for line in open(f, encoding="utf-8", errors="ignore"):
            try:
                d = json.loads(line)
            except ValueError:
                continue
            ts = d.get("timestamp")
            kind = d.get("type")
            if not ts or kind not in ("user", "assistant"):
                continue
            t = datetime.datetime.fromisoformat(ts.replace("Z", "+00:00"))
            m = d.get("message") or {}
            if not sub:
                content = m.get("content")
                is_director = (kind == "user" and isinstance(content, str) and not d.get("isMeta")
                               and not content.startswith("Another Claude session"))
                events.append((t, is_director))
            u = m.get("usage")
            if kind != "assistant" or not u:
                continue
            vals = [u.get("input_tokens", 0), u.get("output_tokens", 0),
                    u.get("cache_creation_input_tokens", 0), u.get("cache_read_input_tokens", 0)]
            key = (f, m.get("id"))
            if key not in msgs:
                msgs[key] = [role, m.get("model", "?"), t, vals]
            else:
                cur = msgs[key][3]
                for i in range(4):
                    cur[i] = max(cur[i], vals[i])
    return list(msgs.values()), events


def cost_of(rows, nocache=False, force=None):
    total = 0.0
    for role, model, t, (i, o, cw, cr) in rows:
        p = price(force or model, i + cw + cr)
        if not p:
            continue
        if nocache:
            total += ((i + cw + cr) * p[0] + o * p[1]) / 1e6
        else:
            total += (i * p[0] + o * p[1] + cr * p[2] + cw * p[3]) / 1e6
    return total


def hours(events):
    events.sort(key=lambda e: e[0])
    keyboard = agent = 0.0
    prev = None
    for t, is_director in events:
        if prev is not None:
            dt = (t - prev).total_seconds()
            if 0 <= dt <= 1800:
                if is_director:
                    keyboard += dt
                else:
                    agent += dt
        prev = t
    return keyboard / 3600, agent / 3600


def report(name, project_dir):
    rows, events = load(project_dir)
    if not rows:
        return
    by_role = collections.Counter()
    kinds = collections.Counter()
    tokens = collections.Counter()
    first = min(r[2] for r in rows)
    last = max(r[2] for r in rows)
    for role, model, t, (i, o, cw, cr) in rows:
        p = price(model, i + cw + cr)
        if not p:
            continue
        by_role[role] += (i * p[0] + o * p[1] + cr * p[2] + cw * p[3]) / 1e6
        kinds["cache reads"] += cr * p[2] / 1e6
        kinds["cache writes"] += cw * p[3] / 1e6
        kinds["output"] += o * p[1] / 1e6
        kinds["fresh input"] += i * p[0] / 1e6
        tokens["all"] += i + o + cw + cr
        tokens["cache reads"] += cr
        tokens["output"] += o
    total = sum(by_role.values())
    kb, ag = hours(events)
    print(f"== {name}  ({first:%Y-%m-%d} to {last:%Y-%m-%d})")
    print(f"   API-equivalent ${total:,.2f}; {tokens['all'] / 1e9:.2f} billion tokens, "
          f"{tokens['cache reads'] / max(tokens['all'], 1) * 100:.0f}% cache reads, "
          f"{tokens['output'] / 1e6:.2f}M output")
    print("   cost by kind: " + ", ".join(f"{k} {v / total * 100:.0f}%" for k, v in kinds.most_common()))
    print(f"   orchestrating session {by_role['main'] / total * 100:.0f}%, subagents {by_role['sub'] / total * 100:.0f}%")
    print(f"   director at the keyboard {kb:.1f} h, agent on its own {ag:.1f} h"
          + (f"; ${total / kb:.0f} per keyboard hour" if kb else ""))
    print(f"   if nothing were cached ${cost_of(rows, nocache=True):,.0f}; all Opus 5.5 ${cost_of(rows, force='claude-opus-5-5'):,.0f}; "
          f"all Sonnet 5.5 ${cost_of(rows, force='claude-sonnet-5-5'):,.0f}")


def weekly():
    weeks = collections.defaultdict(float)
    for project_dir in glob.glob(os.path.join(ROOT, "*")):
        rows, _ = load(project_dir)
        for role, model, t, (i, o, cw, cr) in rows:
            p = price(model, i + cw + cr)
            if not p:
                continue
            monday = (t - datetime.timedelta(days=t.weekday())).strftime("%Y-%m-%d")
            weeks[monday] += (i * p[0] + o * p[1] + cr * p[2] + cw * p[3]) / 1e6
    for wk in sorted(weeks):
        print(f"week of {wk}  ${weeks[wk]:8,.0f}")


def main(argv):
    if "--weekly" in argv:
        weekly()
        return
    dirs = sorted(glob.glob(os.path.join(ROOT, "*")))
    if argv:
        dirs = [d for d in dirs if argv[0] in os.path.basename(d)]
    for d in dirs:
        if os.path.isdir(d):
            report(os.path.basename(d), d)


if __name__ == "__main__":
    main(sys.argv[1:])
