. ~/.commonrc

parse_git_branch() {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ \1/'
}

case "%TERM" in
  linux|screen)
    export PS1='>>> '
    ;;
  **)
    export PS1=$'%{\e]2;<%m> %~%}\e<%m> %B%F{yellow}%*%b%f (%F{red}%j%f%) >>> '
    #export PS1=$'\e]2;<%m> %~\e<%m> \e[33;1m%*\e[0m (\e[35;1m%j\e[0m%)$(parse_git_branch) >>> '
    ;;
esac
