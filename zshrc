. ~/.commonrc

if [ -d ~/.oh-my-zsh ]
then
  export ZSH=~/.oh-my-zsh
  #export ZSH_THEME=random
  # short list:
  #export ZSH_THEME=afowler
  export ZSH_THEME=arrow
  #export ZSH_THEME=clean
  #export ZSH_THEME=cloud
  #export ZSH_THEME=daveverwer
  #export ZSH_THEME=eastwood
  #export ZSH_THEME=galois
  #export ZSH_THEME=gentoo
  #export ZSH_THEME=lambda
  #export ZSH_THEME=lukerandall
  #export ZSH_THEME=philips
  #export ZSH_THEME=risto
  #export ZSH_THEME=simple
  #export ZSH_THEME=tonotdo
  #export ZSH_THEME=wezm

  plugins=(git rvm brew heroku npm osx powder redis-cli)
  source $ZSH/oh-my-zsh.sh
else
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
fi
