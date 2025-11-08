
export EDITOR="nvim"
export VISUAL="nvim"



# Inserted by de2 installer
source ~/.lattice-magic-zsh

# Add /bin/env to path
. "$HOME/.local/bin/env"


if [[ -z "$SHELL_INITIALIZED" ]]; then
    source ~/.config/shell/init.sh
    source ~/.config/shell/variables.sh
fi

source ~/.config/shell/zsh/options.sh
source ~/.config/shell/shortcuts.sh

source ~/.config/shell/apps/atac.sh
source ~/.config/shell/apps/brew.sh
source ~/.config/shell/apps/git.sh
source ~/.config/shell/apps/lattice.sh
source ~/.config/shell/apps/lazygit.sh
source ~/.config/shell/apps/mvp.sh
source ~/.config/shell/apps/neovim.sh
source ~/.config/shell/apps/overmind.sh
source ~/.config/shell/apps/pnpm.sh
source ~/.config/shell/apps/starship.sh
