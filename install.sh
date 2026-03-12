#!/bin/sh
set -e

echo "Installing git-shortcuts..."

# create <branch> <message> — new branch, stage all, commit
git config --global alias.create '!f() { git checkout -b "$1" && git add -A && git commit -m "${*:2}"; }; f'

# save <message> — stage all, new commit
git config --global alias.save '!f() { git add -A && git commit -m "$*"; }; f'

# modify [-A] — amend last commit (tracked files only, or -A for all)
git config --global alias.modify '!f() { if [ "$1" = "-A" ]; then git add -A; else git add -u; fi && git commit --amend --no-edit; }; f'

# submit — push, open/create draft PR
git config --global alias.submit '!f() { git push -u origin HEAD --force-with-lease && if gh pr view HEAD --json url >/dev/null 2>&1; then gh pr view HEAD --web; else gh pr create --fill --web --draft; fi; }; f'

# sync — fetch and rebase onto origin/main
git config --global alias.sync '!git fetch origin && git rebase origin/main'

echo "Done! The following git commands are now available:"
echo "  git create <branch> <message>  — new branch + commit"
echo "  git save <message>             — stage all + commit"
echo "  git modify [-A]                — amend last commit"
echo "  git submit                     — push + open/create draft PR"
echo "  git sync                       — rebase onto origin/main"
