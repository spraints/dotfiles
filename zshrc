. ~/.commonrc

case "%TERM" in
  linux)
    export PS1=$'>>> '
    ;;
  **)
    export PS1=$'%{\e]2;<%m> %~%0G%}\e<%m> %B%F{yellow}%*%b%f (%F{red}%j%f%) >>> '
    #export PS1=$'\e]2;<%m> %~\e<%m> \e[33;1m%*\e[0m (\e[35;1m%j\e[0m%)$(parse_git_branch) >>> '
    ;;
esac
