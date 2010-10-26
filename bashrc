# bashrc is executed by bash for non-login shells.

# Load RVM
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

alias vpn='ssh -C -L3389:niftier:3389 -D6543 -L2222:git.sep.com:22 maburke@raiders.sep.com'

function parse_git_dirty {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "*"
}
function parse_git_branch {
  #git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/ [\1$(parse_git_dirty)]/"
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/ [\1]/"
}
export PS1='\[\e]2;<\h> \w\a\]<\h> \[\e[33;1m\]\t \[\e[0m\](\[\e[35;1m\]\j\[\e[0m\])$(parse_git_branch) >>> '

