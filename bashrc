# bashrc is executed by bash for non-login shells.

. ~/.commonrc

function parse_git_dirty {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "*"
}
function current-branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/^* //'
}
function parse_git_branch {
  local branch="$(current-branch)"
  test -n "$branch" && printf " [%s]" "$(current-branch)"
}
function audible_ps1 {
  if [ $# -gt 0 ]; then
    local words=
    while [ $# -gt 0 ]; do
      case "$1" in
        --help|-h)
          echo "Usage: audible_ps1 --off"
          echo "Usage: audible_ps1 WORDS"
          return ;;
        --off)
          unset AUDIBLE_PS1
          return ;;
        *)
          words="${words} $1"
          shift ;;
      esac
    done
    export AUDIBLE_PS1="${words}"
  else
    if [ -n "${AUDIBLE_PS1}" ]; then
      say "${AUDIBLE_PS1}"
    fi
  fi
}
export PS1='[$$] \[\e[33;1m\]\t \[\e[0m\](\[\e[35;1m\]\j\[\e[0m\])$(parse_git_branch)$(audible_ps1) >>> '

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

viconflicts() {
  local conflicts="$(git status --porcelain | grep ^UU | awk '{print $2}')"
  test -n "$conflicts" && vi $conflicts
}

shuf_args() {
  for arg in "$@"; do
    echo $(rand2) "$arg"
  done | sort | cut -c 5- | tr "\n" " "
}

rand2() {
  dd if=/dev/random of=/dev/stdout bs=2 count=1 2>/dev/null | od -t x2  | head -1 | awk '{print $2}'
}

a() {
  local g=~/github/"$1"
  local d=~/dev/"$1"
  if [ -d "$g" ]
  then
    atom "$g"
  else
    if [ -d "$d" ]
    then
      atom "$d"
    else
      atom "$1"
    fi
  fi
}

# Run a console
sc() {
  if [ -e bin/console ]; then
    bin/console "$@"
  elif [ -e script/console ]; then
    script/console "$@"
  elif [ -e bin/rails ]; then
    bin/rails console "$@"
  else
    echo "Sorry, I don't know how to run a console here. :("
  fi
}

# Fail-fast test
fft() {
  if [ -e "script/fail-fast-test" ]; then
    script/fail-fast-test "$@"
  elif [ -e bin/rspec && -d spec ]; then
    bin/rspec --fail-fast "$@"
  else
    echo "Sorry, I don't know how to run a console here. :("
  fi
}

PERL_MB_OPT="--install_base \"/Users/spraints/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/Users/spraints/perl5"; export PERL_MM_OPT;
