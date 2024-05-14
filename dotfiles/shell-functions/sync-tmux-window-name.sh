sync-tmux-window-name() {
  tmux rename-window "$(basename "$(pwd)")"
}

# ok: zsh
