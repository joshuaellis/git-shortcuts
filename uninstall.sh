#!/bin/sh
set -e

echo "Removing git-shortcuts..."

git config --global --unset alias.create 2>/dev/null || true
git config --global --unset alias.save 2>/dev/null || true
git config --global --unset alias.modify 2>/dev/null || true
git config --global --unset alias.submit 2>/dev/null || true
git config --global --unset alias.sync 2>/dev/null || true

echo "Done! All git-shortcuts aliases have been removed."
