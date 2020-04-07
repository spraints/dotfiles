function audible_ps1 {
  if [ $# -gt 0 ]; then
    local words=
    unset AUDIBLE_PS1_VOICE
    unset AUDIBLE_PS1
    while [ $# -gt 0 ]; do
      case "$1" in
        --off)
          unset AUDIBLE_PS1
          return ;;
        -v)
          AUDIBLE_PS1_VOICE="$2"
          shift; shift ;;
        -*)
          echo "Usage: audible_ps1 --off"
          echo "Usage: audible_ps1 WORDS"
          return ;;
        *)
          words="${words} $1"
          shift ;;
      esac
    done
    export AUDIBLE_PS1="${words}"
  else
    if [ -n "${AUDIBLE_PS1}" ]; then
      if [ -n "${AUDIBLE_PS1_VOICE}" ]; then
        say -v "${AUDIBLE_PS1_VOICE}" "${AUDIBLE_PS1}"
      else
        say "${AUDIBLE_PS1}"
      fi
    fi
  fi
}
