#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {
  local src_rel="$1"
  local dest_rel="${2:-$src_rel}"
  local src="$DOTFILES/$src_rel"
  local dest="$HOME/$dest_rel"

  mkdir -p "$(dirname "$dest")"

  if [ -L "$dest" ]; then
    if [ "$(readlink "$dest")" = "$src" ]; then
      echo "  ok  $dest_rel"
      return
    fi
    rm "$dest"
  elif [ -e "$dest" ]; then
    echo "  bak $dest_rel → $dest.bak"
    mv "$dest" "$dest.bak"
  fi

  ln -s "$src" "$dest"
  echo "  ->  $dest_rel"
}

echo "Linking dotfiles from $DOTFILES to $HOME"
echo

# Top-level files
link zshrc .zshrc
link profile .profile
link tmux.conf .tmux.conf
link tmux.common.conf .tmux.common.conf
link overmind.env .overmind.env
link overmind.tmux.conf .overmind.tmux.conf
link wezterm.lua .wezterm.lua

# .config — symlink each subdirectory/file
link config/brew .config/brew
link config/btop .config/btop
link config/gh .config/gh
link config/gh-dash .config/gh-dash
link config/ghostty .config/ghostty
link config/keyboard.json .config/keyboard.json
link config/lazygit .config/lazygit
link config/mpv .config/mpv
link config/ngrok .config/ngrok
link config/nvim .config/nvim
link config/rainfrog .config/rainfrog
link config/shell .config/shell
link config/starship.toml .config/starship.toml
link config/uv .config/uv
link config/worktrunk .config/worktrunk

# .claude — individual files only (dir has untracked runtime content)
link claude/policy-limits.json .claude/policy-limits.json
link claude/settings.json .claude/settings.json
link claude/statusline-command.sh .claude/statusline-command.sh

# .sqlit
link sqlit .sqlit

echo
echo "Done."
