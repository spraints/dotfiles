newworktree() {
  local usage="Usage: newworktree [--help] [-h] [--no-fetch] [--base start] branch-name"
  local branch=
  for arg; do
    case "$arg" in
      --help)
        echo "$usage"
        return
        ;;
      -*)
        : ;; # ignore
      *)
        branch="$arg"
        break
        ;;
    esac
  done
  if [ -z "$branch" ]; then
    echo "$usage"
    return
  fi
  local dst=/dev/null
  case "$(git rev-parse --git-dir)" in
    */.git)
      dst="$(git rev-parse --show-toplevel)-$1"
      ;;
    */.git/worktrees/*)
      dst="$(dirname "$(git rev-parse --git-common-dir)")-$1"
      ;;
    *)
      echo "could not figure out where the worktree should go"
      return 1
      ;;
  esac
  git worktree add "$dst"
  cd "$dst"
  sync-tmux-window-name
  newbranch "$1"
}

# ok: zsh
