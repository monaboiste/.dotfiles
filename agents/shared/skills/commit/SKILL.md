---
name: commit
description: Group uncommitted changes into feature commits.
---

1. Run `git status` and `git diff` to understand all changes
2. Group changed files by logical feature
3. Run `git log -5 --oneline` to understand the convention of the commit
   messages, prefer lower case
4. Propose action-oriented commit messages
5. Print proposed commit messages and ask for user feedback/approval
6. Stage and commit each group
7. Repeat until all changes are committed
