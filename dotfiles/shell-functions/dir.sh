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
  case "$#" in
    1)
      local arg="$1"
      case "$arg" in
        gh|github)
          arg="github/github";;
        .|..)
          __dir_usage
          return ;;
      esac

      for d in \
        "${arg}" \
        "${HOME}/${arg}" \
        "${HOME}/src/${arg}" \
        "${HOME}/src/github.com/${arg}" \
        "${HOME}/src/github.com/github/${arg}" \
        "${HOME}/src/github.com/spraints/${arg}" \
        "${HOME}/src/github.com/farmingengineers/${arg}" \
        "${HOME}/src/experiments/${arg}"
      do
        if [ -d "$d" ]; then
          echo ">> cd $d"
          cd "$d"
          sync-tmux-window-name >&/dev/null
          return
        fi
      done
      echo "$1: no match"
      ;;

    *)
      __dir_usage
      ;;
  esac
}

# ok: zsh
