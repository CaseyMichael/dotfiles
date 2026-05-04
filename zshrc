
export EDITOR="nvim"
export VISUAL="nvim"

# Inserted by de2 installer
[ -f ~/.lattice-magic-zsh ] && source ~/.lattice-magic-zsh

# Add /bin/env to path
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

source ~/.config/shell/init.sh
source ~/.config/shell/variables.sh
source ~/.config/shell/zsh/options.sh
source ~/.config/shell/shortcuts.sh


# source all files in the ~/.config/shell/apps dir
for f in ~/.config/shell/apps/*.sh; do
  if [ -r "$f" ] && [ -f "$f" ]; then
    . "$f"
  fi
done

# pnpm
export PNPM_HOME="/Users/casey/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Worktrunk shell autocomplete
if command -v wt >/dev/null 2>&1; then eval "$(command wt config shell init zsh)"; fi

USE_DATADOG_MCP=true

export DEVPLAT_USE_ANTHROPIC_CLAUDE_CODE_AUTH=true
