devvpn() {
  case "${1:-}" in
    connect)
      open -a Google\ Chrome https://fido-challenger.githubapp.com/auth/vpn-devvpn
      osascript -e 'tell application "Viscosity" to connect "github-iad-devvpn"' ;;
    disconnect)
      osascript -e 'tell application "Viscosity" to disconnect "github-iad-devvpn"' ;;
    *)
      echo 'Usage: devvpn connect|disconnect' ;;
  esac
}
