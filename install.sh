#!/bin/sh
set -e

echo "Installing git-shortcuts..."

# create <branch> <message> — new branch, stage all, commit
git config --global alias.create '!f() { git checkout -b "$1" && git add -A && git commit -m "${*:2}"; }; f'

# save <message> — stage all, new commit
git config --global alias.save '!f() { git add -A && git commit -m "$*"; }; f'

# modify [-A] — amend last commit (tracked files only, or -A for all)
git config --global alias.modify '!f() { if [ "$1" = "-A" ]; then git add -A; else git add -u; fi && git commit --amend --no-edit; }; f'

# submit — push, open/create draft PR (uses repo PR template if found)
git config --global alias.submit '!f() { git push -u origin HEAD --force-with-lease && if gh pr view --json url >/dev/null 2>&1; then gh pr view --web; else tpl=""; for p in .github/pull_request_template.md .github/PULL_REQUEST_TEMPLATE.md pull_request_template.md docs/pull_request_template.md; do if [ -f "$p" ]; then tpl="$p"; break; fi; done; if [ -n "$tpl" ]; then gh pr create --fill --template "$tpl" --draft; else gh pr create --fill --draft; fi && gh pr view --web; fi; }; f'

# sync — fetch and rebase onto origin/main
git config --global alias.sync '!git fetch origin && git rebase origin/main'

# delta — better diffs
if command -v delta >/dev/null 2>&1; then
  git config --global core.pager delta
  git config --global interactive.diffFilter "delta --color-only"
  git config --global delta.navigate true
  git config --global delta.side-by-side true
  git config --global delta.line-numbers true
  git config --global merge.conflictStyle zdiff3
  echo "delta detected — configured as git pager."
else
  echo ""
  echo "⚠ delta not found — diffs will use the default pager."
  echo "  Install it for syntax-highlighted, side-by-side diffs:"
  echo "    brew install git-delta"
  echo "  https://github.com/dandavison/delta"
  echo ""
fi

echo "Done! The following git commands are now available:"
echo "  git create <branch> <message>  — new branch + commit"
echo "  git save <message>             — stage all + commit"
echo "  git modify [-A]                — amend last commit"
echo "  git submit                     — push + open/create draft PR"
echo "  git sync                       — rebase onto origin/main"
