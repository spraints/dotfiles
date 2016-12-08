# bashrc is executed by bash for non-login shells.

. ~/.commonrc

function parse_git_dirty {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "*"
}
function current-branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/^* //'
}
function parse_git_branch {
  printf " [%s]" "$(current-branch)"
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
  base=origin/master
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
  git checkout --no-track -b "$branch_name" "$base"
  )
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
