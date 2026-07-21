---
name: commit
description: Group uncommitted changes into clean, logical feature commits.
---

1. Run `git status -u` and `git diff` to analyze all changes.
2. Run `git log -5 --oneline` to adapt to the repo's commit message style.
3. Group files logically (by feature/fix/docs).
4. Draft action-oriented commit messages in imperative mood (subject ≤50 chars; wrap body at 72 chars/line).
5. Show proposed file groups and commit messages to the user for approval.
6. Stage (`git add`) and commit each approved group.
