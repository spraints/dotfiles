sfd_uuid=eca72d9d-e120-4fb3-a659-dbca18c44f0d
vm() {
  case "${1:-}" in
    "up")
      shift
      VBoxManage startvm $sfd_uuid "$@" ;;
    "down")
      VBoxManage controlvm $sfd_uuid shutdown ;;
    "pause")
      VBoxManage controlvm $sfd_uuid pause ;;
    "resume")
      VBoxManage controlvm $sfd_uuid resume ;;
    "screenshot")
      VBoxManage controlvm $sfd_uuid screenshotpng "${HOME}/.sfd-screenshot.png"
      open "${HOME}/.sfd-screenshot.png" ;;
    "ssh")
      ssh sfd ;;
    *)
      echo 'Usage: vm up|down|pause|resume|screenshot|ssh'
      return 1 ;;
  esac
}
