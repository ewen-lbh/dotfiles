# coding: utf-8
import json
from pathlib import Path
from subprocess import run

commits = run(["git", "--no-pager", "log", "--pretty=format:%s"], capture_output=True).stdout.decode().splitlines()
categories = {}

for commit in commits:
    if ': ' not in commit: continue
    cat, *message = commit.split(': ')
    if cat in categories:
        categories[cat].append(': '.join(message))
    else:
        categories[cat] = [': '.join(message)]

(Path.home() / ".dotfiles" / "categorized-commits.json").write_text(json.dumps(categories))
