cbosxsensorservice() {
  case "$1" in
    start|resume)
      sudo launchctl load /Library/LaunchDaemons/com.carbonblack.daemon.plist ;;
    stop|pause)
      sudo launchctl unload /Library/LaunchDaemons/com.carbonblack.daemon.plist ;;
    status)
      ps ax | grep -i [c]bosx
      sudo lsof -nP -c CbOsxSens | grep IP
      ;;
    tr*)
      # If my network is having trouble and I want to limit CB's footprint.
      sudo dnctl pipe 1 config bw 1Kbit/s queue 5 ;;
    qu*)
      # Somewhere between trickle and normal.
      sudo dnctl pipe 1 config bw 50Kbit/s queue 10 ;;
    no*)
      # Typically, 100kbps is not a problem.
      sudo dnctl pipe 1 config bw 100Kbit/s queue 25 ;;
    fa*)
      # When /private/var/lib/cb/store gets backed up, open the gates a bit.
      sudo dnctl pipe 1 config bw 500Kbit/s queue 25 ;;
    un*)
      # I might want to do this ???
      sudo dnctl pipe 1 config bw 0 queue 50 ;;
    enable-pf)
      # Check if it's already enabled?
      sudo pfctl -s info 2>/dev/null | grep "^Status: Enabled"
      echo TODO
      #   sudo pfctl -s References
      # Enable if necessary.
      #   sudo pfctl -E
      # Add my anchors, if necessary.
      #   sudo pfctl -a spraints -f /etc/pf.anchors/spraints
      # Add the dummynet pipe, if necessary.
      #   sudo dnctl pipe 1 config bw 10Kbit/s
      ;;
    *)
      echo 'Usage: cbosxsensorservice start|stop|status|enable-pf|SPEED'
      echo 'where SPEED is one of'
      echo '  trickle -   1 kbps'
      echo '  quiet   -  50 kbps'
      echo '  normal  - 100 kbps'
      echo '  fast    - 500 kbps'
      echo '  unrestrained'
      echo 'or manually set: sudo dnctl pipe 1 config bw 10Kbit/s queue 25'
      ;;
  esac
}
