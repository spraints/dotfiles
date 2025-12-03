__dir_usage() {
  cat <<USAGE
Usage: dir DIR
where DIR is one of:
  - a directory in the current directory
  - a directory in HOME
  - a directory in src/
  - a directory in src/github.com/
  - a directory in src/github.com/github/
  - a directory in src/github.com/spraints/
USAGE
}

dir() {
  local dest="$(_choose_dir_dest "$@")"
  if [ -n "$dest" ]; then
    echo ">> cd $dest"
    cd "$dest"
    sync-tmux-window-name >&/dev/null
  else
    __dir_usage
    return 1
  fi
}

_choose_dir_dest() {
  if [ "$#" -ne 1 ]; then
    return 1
  fi

  case "$1" in
    .dotfiles)
      echo ${HOME}/.dotfiles ;;
    .|..)
      return 1 ;;
    */*)
      echo "$1" ;;
    *)
      fd --type dir --max-depth 3 "$1" ${HOME}/src | sort -r | head -n 1 ;;
  esac
}

if [ "zsh" = "`basename ${SHELL}`" ]; then
  _dir() {
    local -a completions

    # Add .dotfiles as a special completion
    completions+=(".dotfiles")

    # Add directories in current directory (excluding . and ..)
    for d in */ ; do
      if [ "$d" != "./" ] && [ "$d" != "../" ]; then
        completions+=("${d%/}")
      fi
    done

    # Add directories found in ${HOME}/src
    if [ -d "${HOME}/src" ]; then
      while IFS= read -r line; do
        # Extract just the directory name (last component of path)
        local dirname="${line##*/}"
        completions+=("$dirname")
      done < <(fd --type dir --max-depth 3 . ${HOME}/src 2>/dev/null | sort -u)
    fi

    # Provide completions
    _describe 'directories' completions
  }

  compdef _dir dir
fi

# ok: zsh
