#!/bin/sh
set -e

echo "Installing git-shortcuts..."

# create <branch> <message> — new branch, stage all, commit, track parent for stacking
git config --global alias.create '!f() { parent=$(git branch --show-current) && git checkout -b "$1" && git config branch."$1".parent "$parent" && git add -A && git commit -m "${*:2}"; }; f'

# down — move to parent branch in the stack
git config --global alias.down '!f() { current=$(git branch --show-current) && parent=$(git config branch."$current".parent 2>/dev/null) || true; if [ -z "$parent" ]; then echo "No parent branch set for $current."; exit 1; fi; git checkout "$parent"; }; f'

# up — move to child branch in the stack
git config --global alias.up '!f() { current=$(git branch --show-current); children=""; for b in $(git for-each-ref --format="%(refname:short)" refs/heads); do p=$(git config branch."$b".parent 2>/dev/null) || true; if [ "$p" = "$current" ]; then children="${children:+$children\n}$b"; fi; done; count=$(printf "%b" "$children" | grep -c . 2>/dev/null || echo 0); if [ "$count" -eq 0 ]; then echo "No child branches for $current."; exit 1; elif [ "$count" -eq 1 ]; then git checkout "$children"; else echo "Multiple children:"; printf "%b\n" "$children" | nl -ba; printf "Choose [1-%s]: " "$count"; read n; child=$(printf "%b\n" "$children" | sed -n "${n}p"); git checkout "$child"; fi; }; f'

# stack — show the current branch stack
git config --global alias.stack '!f() { current=$(git branch --show-current); branch="$current"; stack=""; while [ -n "$branch" ]; do stack="$branch\n$stack"; parent=$(git config branch."$branch".parent 2>/dev/null) || true; if [ -z "$parent" ]; then break; fi; branch="$parent"; done; printf "%b" "$stack" | while IFS= read -r b; do [ -z "$b" ] && continue; if [ "$b" = "$current" ]; then printf "* %s\n" "$b"; else printf "  %s\n" "$b"; fi; done; }; f'

# save <message> — stage all, new commit
git config --global alias.save '!f() { git add -A && git commit -m "$*"; }; f'

# modify [-A] — amend last commit (tracked files only, or -A for all)
git config --global alias.modify '!f() { if [ "$1" = "-A" ]; then git add -A; else git add -u; fi && git commit --amend --no-edit; }; f'

# submit — push, open/create PR (uses repo PR template if found)
git config --global alias.submit '!f() { draft=""; if [ "$1" = "--draft" ]; then draft="--draft"; fi; git push -u origin HEAD --force-with-lease && if gh pr view --json url >/dev/null 2>&1; then gh pr view --web; else tpl=""; for p in .github/pull_request_template.md .github/PULL_REQUEST_TEMPLATE.md pull_request_template.md docs/pull_request_template.md; do if [ -f "$p" ]; then tpl="$p"; break; fi; done; if [ -n "$tpl" ]; then gh pr create --fill --body-file "$tpl" $draft; else gh pr create --fill $draft; fi && gh pr view --web; fi; }; f'

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
echo "  git submit [--draft]           — push + open/create PR"
echo "  git sync                       — rebase onto origin/main"
echo "  git up                         — move to child branch in stack"
echo "  git down                       — move to parent branch in stack"
echo "  git stack                      — show current branch stack"
