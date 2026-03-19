#!/bin/sh
set -e

echo "Removing git-shortcuts..."

git config --global --unset alias.create 2>/dev/null || true
git config --global --unset alias.save 2>/dev/null || true
git config --global --unset alias.modify 2>/dev/null || true
git config --global --unset alias.submit 2>/dev/null || true
git config --global --unset alias.sync 2>/dev/null || true
git config --global --unset alias.up 2>/dev/null || true
git config --global --unset alias.down 2>/dev/null || true
git config --global --unset alias.stack 2>/dev/null || true
git config --global --unset alias.go 2>/dev/null || true

# delta config
git config --global --unset core.pager 2>/dev/null || true
git config --global --unset interactive.diffFilter 2>/dev/null || true
git config --global --unset delta.navigate 2>/dev/null || true
git config --global --unset delta.side-by-side 2>/dev/null || true
git config --global --unset delta.line-numbers 2>/dev/null || true
git config --global --unset merge.conflictStyle 2>/dev/null || true

echo "Done! All git-shortcuts aliases and delta config have been removed."
