sync-tmux-window-name() {
  local name="$(basename "$(pwd)")"
  case "$name" in
    gnucash_reports)
      tmux rename-window '$$' ;;
    *)
      tmux rename-window "${name}" ;;
  esac
}

# ok: zsh
