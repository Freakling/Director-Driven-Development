#!/usr/bin/env bash
# Project check step: the docs site selftest (dashes, docs coverage of every framework
# command, and a strict MkDocs build that fails on broken links). See selftest.sh.
exec bash selftest.sh
