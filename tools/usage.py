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
    python tools/usage.py --tasks <project> <repo> [--csv <file>]
                                               each item of <repo>'s TASKS.md: a subagent by the item its
                                               first prompt names (its kind from .meta.json), the orchestrating
                                               sessions and the director's time by the next item commit

Per project: the total, the share by token kind, the share of the orchestrating session, the
director's hours at the keyboard (every wait of 30 minutes or less that ended with a message
from the director) and the agent's hours on its own, and three counterfactuals: nothing cached,
every call on Opus, every call on Sonnet. Update PRICES when the price list changes, and date
every figure you quote.
"""
import bisect
import collections
import csv
import datetime
import glob
import json
import os
import re
import statistics
import subprocess
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
TASK_ID = r"[TBR]\d+"
TASK_KINDS = ("builder", "reviewer", "researcher")
AFTER_LAST = "(after the last item commit)"
TASKS_USAGE = "usage: python tools/usage.py --tasks <project> <repo> [--csv <file>]"
CSV_FIELDS = ["id", "title", "status", "size", "owner", "total_usd", "builder_reviewer_usd",
              "orchestration_usd", "subagent_minutes", "agent_minutes", "director_minutes",
              "builds", "reviews", "research"]


def price(model, prompt_tokens):
    if model == "claude-haiku-5-5" and prompt_tokens > 100_000:
        model = "claude-haiku-5-5-big"
    return PRICES.get(model)


def row_usd(model, tokens):
    i, o, cw, cr = tokens
    p = price(model, i + cw + cr)
    return 0.0 if not p else (i * p[0] + o * p[1] + cr * p[2] + cw * p[3]) / 1e6


def transcripts(project_dir):
    return glob.glob(os.path.join(project_dir, "**", "*.jsonl"), recursive=True)


def is_subagent(path):
    return "subagent" in path or "/tasks/" in path.replace("\\", "/")


def load(project_dir):
    """One row per assistant message: (role, model, timestamp, [input, output, cache write, cache read], file).
    Also the main sessions' events for the hour counts."""
    msgs = {}
    events = []
    for f in transcripts(project_dir):
        role = "sub" if is_subagent(f) else "main"
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
            if role == "main":
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
                msgs[key] = [role, m.get("model", "?"), t, vals, f]
            else:
                cur = msgs[key][3]
                for i in range(4):
                    cur[i] = max(cur[i], vals[i])
    return list(msgs.values()), events


def cost_of(rows, nocache=False, force=None):
    total = 0.0
    for role, model, t, (i, o, cw, cr), _ in rows:
        p = price(force or model, i + cw + cr)
        if not p:
            continue
        if nocache:
            total += ((i + cw + cr) * p[0] + o * p[1]) / 1e6
        else:
            total += (i * p[0] + o * p[1] + cr * p[2] + cw * p[3]) / 1e6
    return total


def gaps(events):
    """Each wait of 30 minutes or less, as (the time it ended, its seconds, whether the director's message ended it)."""
    events.sort(key=lambda e: e[0])
    prev = None
    for t, is_director in events:
        if prev is not None:
            dt = (t - prev).total_seconds()
            if 0 <= dt <= 1800:
                yield t, dt, is_director
        prev = t


def hours(events):
    keyboard = agent = 0.0
    for _, dt, is_director in gaps(events):
        if is_director:
            keyboard += dt
        else:
            agent += dt
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
    for role, model, t, (i, o, cw, cr), _ in rows:
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
        for role, model, t, (i, o, cw, cr), _ in rows:
            p = price(model, i + cw + cr)
            if not p:
                continue
            monday = (t - datetime.timedelta(days=t.weekday())).strftime("%Y-%m-%d")
            weeks[monday] += (i * p[0] + o * p[1] + cr * p[2] + cw * p[3]) / 1e6
    for wk in sorted(weeks):
        print(f"week of {wk}  ${weeks[wk]:8,.0f}")


def task_items(repo):
    """TASKS.md's items: id -> (title, status, size, owner)."""
    items = {}
    with open(os.path.join(repo, "TASKS.md"), encoding="utf-8") as fh:
        for line in fh:
            # The size may carry a note, such as "L (sized M)"; its first word is the size.
            m = re.match(r"### (" + TASK_ID + r") · (.*?) · (todo|in-progress[^·]*|done[^·]*) · ([^·]+?) · (\w+)", line)
            if m:
                items[m.group(1)] = (m.group(2), m.group(3).split()[0], m.group(4).split()[0], m.group(5))
    return items


def item_commits(repo):
    """The item commits, oldest first: their author times, and the item IDs each one names."""
    log = subprocess.run(["git", "-C", repo, "log", "--format=%aI%x09%s"], capture_output=True,
                         text=True, encoding="utf-8", check=True).stdout
    commits = []
    for line in log.splitlines():
        ts, subject = line.split("\t", 1)
        m = re.search(r"\((" + TASK_ID + r"(?:,\s*" + TASK_ID + r")*)\)\s*$", subject)
        if m:
            commits.append((datetime.datetime.fromisoformat(ts), re.findall(TASK_ID, m.group(1))))
    commits.sort(key=lambda c: c[0])
    return [c[0] for c in commits], [c[1] for c in commits]


def ids_after(times, ids, t):
    """The IDs of the first item commit at or after t: the work leading up to that commit is its."""
    k = bisect.bisect_left(times, t)
    return ids[k] if k < len(ids) else [AFTER_LAST]


def share(per, iids, key, amount):
    """Add an amount to each item named, split evenly when one commit names several."""
    for iid in iids:
        per[iid][key] += amount / len(iids)


def text_of(content):
    if isinstance(content, str):
        return content
    if isinstance(content, list):
        return " ".join(b.get("text", "") for b in content if isinstance(b, dict))
    return ""


def subagent_facts(path):
    """A subagent transcript's first prompt, and the times of its first and last messages."""
    first, t0, t1 = None, None, None
    with open(path, encoding="utf-8", errors="ignore") as fh:
        for line in fh:
            try:
                d = json.loads(line)
            except ValueError:
                continue
            ts, kind = d.get("timestamp"), d.get("type")
            if not ts or kind not in ("user", "assistant"):
                continue
            t = datetime.datetime.fromisoformat(ts.replace("Z", "+00:00"))
            t0 = t if t0 is None else min(t0, t)
            t1 = t if t1 is None else max(t1, t)
            if kind == "user" and first is None:
                first = text_of((d.get("message") or {}).get("content"))
    return first or "", t0, t1


def subagent_kind(path):
    """A subagent's kind from its .meta.json: builder, reviewer or researcher, otherwise other."""
    try:
        with open(path[:-len(".jsonl")] + ".meta.json", encoding="utf-8") as fh:
            kind = json.load(fh).get("agentType", "other")
    except (OSError, ValueError):
        kind = "other"
    return kind if kind in TASK_KINDS else "other"


def prompt_item(prompt):
    """The item a subagent's first prompt names: the ID after 'item', else the first ID in it."""
    m = re.search(r"(?:item|Item)\s+(" + TASK_ID + r")\b", prompt) or re.search(r"\b(" + TASK_ID + r")\b", prompt)
    return m.group(1) if m else None


def attribute_subagents(per, project_dir, rows):
    """Each subagent's cost and minutes go to the item its first prompt names. Returns the cost of the rest."""
    file_usd = collections.Counter()
    for role, model, t, tokens, f in rows:
        if role == "sub":
            file_usd[f] += row_usd(model, tokens)
    unnamed = 0.0
    for path in transcripts(project_dir):
        if not is_subagent(path):
            continue
        first, t0, t1 = subagent_facts(path)
        iid = prompt_item(first)
        if iid is None:
            unnamed += file_usd[path]
            continue
        per[iid]["sub_usd"] += file_usd[path]
        per[iid][subagent_kind(path) + "_runs"] += 1
        if t0 is not None:
            per[iid]["sub_min"] += (t1 - t0).total_seconds() / 60
    return unnamed


def attribute_main(per, rows, times, ids):
    """The orchestrating sessions' cost goes to the item whose commit comes next after each message."""
    for role, model, t, tokens, _ in rows:
        if role == "main":
            share(per, ids_after(times, ids, t), "main_usd", row_usd(model, tokens))


def attribute_hours(per, events, times, ids):
    """The director's and the agent's waits go to the item whose commit comes next after each wait."""
    for t, dt, is_director in gaps(events):
        share(per, ids_after(times, ids, t), "director_min" if is_director else "agent_min", dt / 60)


def task_row(iid, c, items):
    title, status, size, owner = items.get(iid, ("", "", "", ""))
    return dict(id=iid, title=title, status=status, size=size, owner=owner,
                total_usd=c["main_usd"] + c["sub_usd"], builder_reviewer_usd=c["sub_usd"],
                orchestration_usd=c["main_usd"], subagent_minutes=c["sub_min"],
                agent_minutes=c["agent_min"], director_minutes=c["director_min"],
                builds=c["builder_runs"], reviews=c["reviewer_runs"], research=c["researcher_runs"])


def csv_value(key, v):
    if key.endswith("_usd"):
        return round(v, 2)
    if key.endswith("_minutes"):
        return round(v)
    return v


def write_csv(path, table):
    with open(path, "w", newline="", encoding="utf-8") as fh:
        w = csv.DictWriter(fh, fieldnames=CSV_FIELDS)
        w.writeheader()
        for r in table:
            w.writerow({k: csv_value(k, v) for k, v in r.items()})


def print_by_size(real):
    print("\nby size (items with cost):  n   total   median  mean   median builder+review min  median director min")
    for size in ["XS", "S", "M", "L", "XL", "-"]:
        g = [r for r in real if r["size"] == size]
        if g:
            print(f"  {size:3} {len(g):4}  ${sum(r['total_usd'] for r in g):7,.0f}  ${statistics.median(r['total_usd'] for r in g):6.2f}  "
                  f"${statistics.mean(r['total_usd'] for r in g):6.2f}   {statistics.median(r['subagent_minutes'] for r in g):5.0f}"
                  f"                     {statistics.median(r['director_minutes'] for r in g):5.0f}")


def print_by_kind(real):
    print("\nby kind:")
    for k in "TBR":
        g = [r for r in real if r["id"].startswith(k)]
        if g:
            print(f"  {k}: {len(g)} items, ${sum(r['total_usd'] for r in g):,.0f}, "
                  f"director {sum(r['director_minutes'] for r in g) / 60:.1f} h")


def print_most_expensive(real):
    print("\nmost expensive:")
    for r in real[:12]:
        print(f"  {r['id']:5} {r['size']:3} ${r['total_usd']:7.2f}  builds {r['builds']} reviews {r['reviews']}  "
              f"director {r['director_minutes']:4.0f} min  {r['title'][:70]}")


def print_tasks(table, items, unnamed, kb, ag):
    real = [r for r in table if r["id"] in items]
    total = sum(r["total_usd"] for r in table) + unnamed
    sub_h = sum(r["subagent_minutes"] for r in table) / 60
    done = sum(1 for v in items.values() if v[1] == "done")
    print(f"total ${total:,.2f} (subagents with no item in their prompt ${unnamed:,.2f}); "
          f"{len(real)} items with cost, {done} done of {len(items)} in TASKS.md")
    print(f"director {kb:.1f} h, orchestrator {ag:.1f} h, subagents {sub_h:.1f} h "
          "(they overlap the orchestrator's waits)")
    for r in table:
        if r["id"] not in items:
            print(f"  not an item: {r['id']}: ${r['total_usd']:,.2f}, director {r['director_minutes']:.0f} min")
    print_by_size(real)
    print_by_kind(real)
    print_most_expensive(real)


def tasks(project_dir, repo, csv_path=None):
    items = task_items(repo)
    times, ids = item_commits(repo)
    rows, events = load(project_dir)
    per = collections.defaultdict(collections.Counter)
    unnamed = attribute_subagents(per, project_dir, rows)
    attribute_main(per, rows, times, ids)
    attribute_hours(per, events, times, ids)
    table = sorted((task_row(iid, c, items) for iid, c in per.items()), key=lambda r: -r["total_usd"])
    if csv_path:
        write_csv(csv_path, table)
    kb, ag = hours(events)
    print_tasks(table, items, unnamed, kb, ag)


def tasks_main(argv):
    csv_path = None
    if "--csv" in argv:
        at = argv.index("--csv")
        if at + 1 == len(argv):
            sys.exit(TASKS_USAGE)
        csv_path = argv[at + 1]
        argv = argv[:at] + argv[at + 2:]
    if len(argv) != 2:
        sys.exit(TASKS_USAGE)
    project, repo = argv
    found = [d for d in glob.glob(os.path.join(ROOT, "*")) if os.path.isdir(d) and project in os.path.basename(d)]
    if not found:
        sys.exit(f"no project folder under {ROOT} matches {project!r}")
    if len(found) > 1:
        sys.exit(f"{project!r} matches {len(found)} project folders, name one: "
                 + ", ".join(sorted(os.path.basename(d) for d in found)))
    if not os.path.isfile(os.path.join(repo, "TASKS.md")):
        sys.exit(f"no TASKS.md in {repo}")
    tasks(found[0], repo, csv_path)


def main(argv):
    if "--weekly" in argv:
        weekly()
        return
    if "--tasks" in argv:
        tasks_main([a for a in argv if a != "--tasks"])
        return
    dirs = sorted(glob.glob(os.path.join(ROOT, "*")))
    if argv:
        dirs = [d for d in dirs if argv[0] in os.path.basename(d)]
    for d in dirs:
        if os.path.isdir(d):
            report(os.path.basename(d), d)


if __name__ == "__main__":
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    main(sys.argv[1:])
