if command -v starship >/dev/null 2>&1; then
  case "$SHELL" in
  */zsh)
    eval "$(starship init zsh)"
    ;;
  */bash)
    eval "$(starship init bash)"
    ;;
  esac
fi
