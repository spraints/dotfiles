# bashrc is executed by bash for non-login shells.

. ~/.commonrc

function parse_git_dirty {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "*"
}
function parse_git_branch {
  #git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/ [\1$(parse_git_dirty)]/"
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/ [\1]/"
}
export PS1='\[\e[33;1m\]\t \[\e[0m\](\[\e[35;1m\]\j\[\e[0m\])$(parse_git_branch) >>> '

alias glg="git log --pretty=format:'%Cred%h %Cblue%t%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr, %an)%Creset' --date=relative --graph"

alias gst='git status'
alias gc='git commit -v'
alias gco='git checkout'
alias ga='git add'
alias gap='git add -p'
alias gai='git add -i'
alias gp='git push'

newbranch() {
  (
  set -e
  usage="Usage: newbranch [--help] [-h] [--no-fetch] branch-name"
  fetch=yes
  while [ $# -gt 0 ]
  do
    case "$1" in
      -h|--help)
        echo $usage
        return ;;
      --no-fetch)
        fetch=no
        shift ;;
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
