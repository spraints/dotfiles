cbosxsensorservice() {
  case "$1" in
    start|resume)
      sudo launchctl load /Library/LaunchDaemons/com.carbonblack.daemon.plist ;;
    stop|pause)
      sudo launchctl unload /Library/LaunchDaemons/com.carbonblack.daemon.plist ;;
    status)
      ps ax | grep -i [c]bosx ;;
    *)
      echo 'Usage: cbosxsensorservice start|stop|status' ;;
  esac
}
