newbranch() {
  (
  set -e
  usage="Usage: newbranch [--help] [-h] [--no-fetch] [--base start] branch-name"
  fetch=yes
  base=
  while [ $# -gt 0 ]
  do
    case "$1" in
      -h|--help)
        echo $usage
        return ;;
      --no-fetch)
        fetch=no
        shift ;;
      --base)
        base="$2"
        shift ; shift ;;
      *)
        if [ $# -eq 1 ]
        then
          branch_name="$1"
          shift
        else
          echo $usage
          return
        fi ;;
    esac
  done
  if [ -z "$branch_name" ]
  then
    echo $usage
    return
  fi
  if [ "$fetch" == "yes" ]
  then
    echo "Fetching from origin..."
    git fetch origin
  fi
  if [ -z "$base" ]
  then
    for r in origin/HEAD origin/main origin/master; do
      if git rev-parse "$r" >&/dev/null; then
        echo "Using $r as base branch."
        base=$(git rev-parse "$r")
        break
      fi
    done
  fi
  if [ -z "$base" ] && [ "$fetch" == "yes" ]
  then
    base=$(git ls-remote origin HEAD | head -n 1 | cut -c1-40)
    if [ -n "$base" ]
    then
      echo "Using origin's HEAD as base branch."
    fi
  fi
  if [ -z "$base" ]
  then
    echo "error: Could not figure out which base branch to use."
    return
  fi
  if ! git rev-parse --verify "${base}^{commit}" >&/dev/null && git rev-parse --verify "origin/${base}^{commit}" >&/dev/null; then
    base="origin/${base}"
  fi
  git checkout --no-track -b "$branch_name" "$base"
  )
}
