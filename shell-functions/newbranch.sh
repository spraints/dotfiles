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
    for r in origin/HEAD origin/master; do
      if git rev-parse "$r" >&/dev/null; then
        base=$(git rev-parse "$r")
        break
      fi
    done
    base=$(git ls-remote origin HEAD | head -n 1 | cut -c1-40)
  fi
  git checkout --no-track -b "$branch_name" "$base"
  )
}
