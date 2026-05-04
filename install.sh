#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {
    local rel="$1"
    local src="$DOTFILES/$rel"
    local dest="$HOME/$rel"

    mkdir -p "$(dirname "$dest")"

    if [ -L "$dest" ]; then
        if [ "$(readlink "$dest")" = "$src" ]; then
            echo "  ok  $rel"
            return
        fi
        rm "$dest"
    elif [ -e "$dest" ]; then
        echo "  bak $rel → $dest.bak"
        mv "$dest" "$dest.bak"
    fi

    ln -s "$src" "$dest"
    echo "  ->  $rel"
}

echo "Linking dotfiles from $DOTFILES to $HOME"
echo

# Top-level files
link .zshrc
link .profile
link .tmux.conf
link .tmux.common.conf
link .overmind.env
link .overmind.tmux.conf
link .wezterm.lua

# .config — symlink each subdirectory/file
link .config/brew
link .config/btop
link .config/gh
link .config/gh-dash
link .config/ghostty
link .config/keyboard.json
link .config/lazygit
link .config/mpv
link .config/ngrok
link .config/nvim
link .config/rainfrog
link .config/shell
link .config/starship.toml
link .config/uv
link .config/worktrunk

# .claude — individual files only (dir has untracked runtime content)
link .claude/policy-limits.json
link .claude/settings.json
link .claude/statusline-command.sh

# .sqlit
link .sqlit

echo
echo "Done."
