
export EDITOR="nvim"
export VISUAL="nvim"

# Inserted by de2 installer
source ~/.lattice-magic-zsh

# Add /bin/env to path
. "$HOME/.local/bin/env"

source ~/.config/shell/init.sh
source ~/.config/shell/variables.sh
source ~/.config/shell/zsh/options.sh
source ~/.config/shell/shortcuts.sh
source ~/.config/shell/secrets.sh


# source all files in the ~/.config/shell/apps dir
for f in ~/.config/shell/apps/*.sh; do
  if [ -r "$f" ] && [ -f "$f" ]; then
    . "$f"
  fi
done
