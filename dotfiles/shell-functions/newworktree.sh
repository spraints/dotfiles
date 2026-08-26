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
  git rev-parse --git-dir
  case "$(git rev-parse --git-dir)" in
    */.git|.git)
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
  tmux new-window -n "$(basename "$dst")" -c "$dst" 'source ~/.shell-functions/newbranch.sh; newbranch "'"$1"'"; exec $SHELL'
}

# ok: zsh
