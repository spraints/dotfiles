devvpn() {
  case "${1:-}" in
    connect)
      osascript -e 'tell application "Viscosity" to connect "github-iad-devvpn"' ;;
    disconnect)
      osascript -e 'tell application "Viscosity" to disconnect "github-iad-devvpn"' ;;
    *)
      echo 'Usage: devvpn connect|disconnect' ;;
  esac
}
