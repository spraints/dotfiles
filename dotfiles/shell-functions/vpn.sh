vpn() {
  case "${1:-}" in
    dev*)
      open -a Google\ Chrome https://fido-challenger.githubapp.com/auth/vpn-devvpn
      osascript -e 'tell application "Viscosity" to connect "github-iad-devvpn"' ;;
    mgmt)
      open -a Google\ Chrome https://fido-challenger.githubapp.com/auth/vpn-mgmt
      osascript -e 'tell application "Viscosity" to connect "github-iad-mgmt"' ;;
    iad|prod)
      open -a Google\ Chrome https://fido-challenger.githubapp.com/auth/vpn-prod
      osascript -e 'tell application "Viscosity" to connect "github-iad-prod"' ;;
    *)
      echo 'Usage: vpn iad|dev' ;;
  esac
}

# ok: zsh
