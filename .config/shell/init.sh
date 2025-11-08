# Brew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Direnv
case "$SHELL" in
*/zsh)
  eval "$(direnv hook zsh)"
  ;;
*/bash)
  eval "$(direnv hook bash)"
  ;;
esac
