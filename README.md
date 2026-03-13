# git-shortcuts

A small set of git aliases inspired by the [Graphite](https://graphite.dev/) CLI.

## Install

```bash
curl -sSL https://raw.githubusercontent.com/joshuaellis/git-shortcuts/main/install.sh | sh
```

## Uninstall

```bash
curl -sSL https://raw.githubusercontent.com/joshuaellis/git-shortcuts/main/uninstall.sh | sh
```

## Commands

| Command                         | Description                                        |
| ------------------------------- | -------------------------------------------------- |
| `git create <branch> <message>` | Create a new branch, stage all files, and commit   |
| `git save <message>`            | Stage all files and commit                         |
| `git modify`                    | Stage tracked files and amend the last commit      |
| `git modify -A`                 | Stage all files (including untracked) and amend    |
| `git submit`                    | Push and open/create a draft PR in the browser     |
| `git sync`                      | Fetch origin and rebase onto `origin/main`         |
| `git up`                        | Move to child branch in the stack                  |
| `git down`                      | Move to parent branch in the stack                 |
| `git stack`                     | Show the current branch stack                      |

## Stacking

`git create` automatically tracks the parent branch so you can navigate stacked PRs:

```
main
  └── feat/auth        ← git create feat/auth "feat: add auth"
        └── feat/login ← git create feat/login "feat: add login page"
```

- `git down` — move to the parent branch
- `git up` — move to a child branch (prompts if multiple children exist)
- `git stack` — print the full stack, highlighting the current branch

## Extras

### delta

If [delta](https://github.com/dandavison/delta) is detected during install, git is automatically configured to use it as the pager with side-by-side, syntax-highlighted diffs.

```bash
brew install git-delta
```

## Requirements

- [git](https://git-scm.com/)
- [gh](https://cli.github.com/) (GitHub CLI) — required for `git submit`
- [delta](https://github.com/dandavison/delta) (optional) — better diffs
