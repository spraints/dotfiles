__dir_usage() {
  cat <<USAGE
Usage: dir DIR
where DIR is one of:
  - a directory in the current directory
  - a subdirectory somewhere in src/
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

  if [ -d "$1" ]; then
    echo "$1"
    return 0
  fi

  case "$1" in
    .dotfiles)
      # special case
      echo ${HOME}/.dotfiles ;;
    .|..)
      return 1 ;;
    */*)
      echo "$1" ;;
    *)
      fd --type dir --max-depth 3 "$1" "${HOME}/src" | __dir_score "$1" | sort -rn | head -n 1 | awk '{print $2}' ;;
  esac
}

__dir_score() {
  local script="$(cat <<SCRIPT
req = ENV["INPUT"]
guess = \$_.strip.chomp("/").split("/").reverse
score =
  case
  when guess[0] == req
    100
  when guess[2] == "github.com" || guess[1] == "experiments"
    50
  when guess[1] == "src"
    25
  else
    0
  end
puts "#{score} #\$_"
SCRIPT
)"
  INPUT="$1" ruby -ne "$script" | tee /dev/stderr
}

# ok: zsh
