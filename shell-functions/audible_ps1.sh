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
