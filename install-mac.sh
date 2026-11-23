#!/usr/bin/env bash
#
# install.sh: set up a Mac from this dotfiles repo.
#
# Installs Homebrew, everything in the Brewfile (apps, font, CLI tools, VS Code
# extensions) and the mise tools (Node, Python, pnpm), links every config into
# the home folder with GNU Stow, then installs the Neovim plugins.
# Safe to re-run.
#

set -euo pipefail

# Repo location: the folder this script is in
DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Output helpers: section heading, warning, fatal error
step() { printf '\n\033[1;35m==> %s\033[0m\n' "$*"; }
warn() { printf '\033[1;33mWarning: %s\033[0m\n' "$*" >&2; }
die()  { printf '\033[1;31mError: %s\033[0m\n' "$*" >&2; exit 1; }

# --- Checks ------------------------------------------------------------------

# The Brewfile and the configs are macOS-only
[[ "$(uname -s)" == "Darwin" ]] || die "This script only runs on macOS."

# The Stow step finishes with `git restore .`, which needs a git clone and
# would discard uncommitted edits to tracked files
cd "$DOTFILES"
git rev-parse --is-inside-work-tree >/dev/null 2>&1 \
  || die "$DOTFILES is not a git clone. Clone the repo with git, then run this again."
[[ -z "$(git status --porcelain --untracked-files=no)" ]] \
  || die "$DOTFILES has uncommitted changes. Commit or stash them, then run this again."

# --- 1. Homebrew -------------------------------------------------------------

# Official installer; it also installs the Xcode Command Line Tools if missing
if [[ ! -x /opt/homebrew/bin/brew ]]; then
  step "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Put brew and the tools it installs on PATH for the rest of this script
# (new shells get it from ~/.zprofile, which the zsh package links)
eval "$(/opt/homebrew/bin/brew shellenv bash)"

# --- 2. Brewfile -------------------------------------------------------------

# Installs, or upgrades, every app, font, CLI tool and VS Code extension listed.
# A failed entry is reported but doesn't stop the script; a re-run retries it.
step "Installing the Brewfile"
brew bundle --file="$DOTFILES/Brewfile" \
  || warn "Some Brewfile entries failed to install. Re-run this script to retry them."

# --- 3. Configs --------------------------------------------------------------

step "Linking configs with GNU Stow"

# Real folders, so Stow links the files inside them instead of turning the
# whole folder into a link to the repo (other apps write into ~/.config, and
# VS Code keeps caches and state next to settings.json)
mkdir -p "$HOME/.config" "$HOME/Library/Application Support/Code/User"

# Link every package (top-level folder) into ~, the target set in .stowrc.
# --adopt moves files already in the way, such as a default ~/.zprofile, into
# the repo so the links can be created; `git restore .` then puts back the
# committed versions.
stow --adopt -- */
git restore .

# --- 4. mise tools -----------------------------------------------------------

# Installs the tools pinned in ~/.config/mise/config.toml (Node, Python, pnpm).
# LazyVim's language servers and formatters run on Node and Python.
step "Installing mise tools"
mise install \
  || warn "Some mise tools failed to install. Re-run this script to retry them."

# --- 5. Neovim plugins -------------------------------------------------------

# Installs LazyVim's plugins at the commits pinned in lazy-lock.json, without
# opening the editor. Language servers and syntax parsers install on the first
# interactive start.
step "Installing Neovim plugins"
nvim --headless "+Lazy! restore" +qa \
  || warn "Neovim plugins didn't finish installing; they install on the next start of nvim."

# --- Summary -----------------------------------------------------------------

# Configs are links into the repo, so a tool rewriting its config shows up here
if [[ -n "$(git status --porcelain)" ]]; then
  warn "Files in $DOTFILES changed during this run. Review them with: git -C $DOTFILES status"
fi

step "Done"
