function tmux-init() {
  # rename first window to shell
  tmux rename-window shell
  # create a new window with the right to be claude and the left to be neovim
  tmux new-window -n "code" \; split-window -h "claude" \; select-pane -L \; send-keys "nvim" C-m
  # create a new window with lazygit
  tmux new-window -d -n "git" "lazygit"
}
