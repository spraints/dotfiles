cbosxsensorservice() {
  case "$1" in
    start|resume)
      sudo launchctl load /Library/LaunchDaemons/com.carbonblack.daemon.plist ;;
    stop|pause)
      sudo launchctl unload /Library/LaunchDaemons/com.carbonblack.daemon.plist ;;
    status)
      echo Checking for my dummynet...
      if ! sudo pfctl -s dummynet -a spraints | grep ^dummynet; then
        printf '%s\n' \
          '***' \
          'My anchor is not defined. Run this:' \
          '  cbosxsensorservice enable-pf'
        return 1
      fi
      echo Checking for my anchor...
      if ! sudo pfctl -s all | grep spraints; then
        printf '%s\n' \
          '***' \
          'My anchors are not loaded in /etc/pf.conf!' \
          'Add these lines there:' \
          '  dummynet-anchor spraints' \
          '  anchor spraints' \
          'Then reload pf' \
          '  sudo pfctl -f /etc/pf.conf'
        return 1
      fi
      echo Other status info:
      ps ax | grep -i [c]bosx
      sudo lsof -nP -c CbOsxSens | grep IP
      sudo dnctl list
      sudo pfctl -s info -a spraints
      ;;
    enable-pf)
      echo Enable packet filter...
      sudo pfctl -e
      echo Installing dummynet rules for CarbonBlack...
      sudo pfctl -a spraints -f /etc/pf.anchors/spraints
      sudo dnctl pipe 1 config bw 100Kbit/s queue 25

      echo Checking for my anchors...
      if ! sudo pfctl -s all | grep spraints; then
        printf '%s\n' \
          '***' \
          'My anchors are not loaded in /etc/pf.conf!' \
          'Add these lines there:' \
          '  dummynet-anchor spraints' \
          '  anchor spraints' \
          'Then reload pf' \
          '  sudo pfctl -f /etc/pf.conf'
        return 1
      fi
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
    watch-dn)
      sudo watch -n 1 dnctl list ;;
    watch-store)
      sudo watch du -sk \
        /private/var/lib/cb \
        /private/var/lib/cb/store \
        /private/var/lib/cb/store_extended \
        /private/var/lib/cb/upgrade \
        ;;
      watch*)
        echo 'Did you mean watch-store or watch-dn?'
        ;;
    *)
      echo 'Usage: cbosxsensorservice start|stop|status|enable-pf|watch-dn|watch-store|SPEED'
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

## Snapshot of /etc/pf.anchors/spraints:
##
## # based on https://blog.leiy.me/post/bw-throttling-on-mac/
## #
## # make sure this is in /etc/pf.conf
## #  dummynet-anchor spraints
## #  anchor spraints
## #
## # also run this:
## #  sudo pfctl -E
## #  sudo pfctl -a spraints -f /etc/pf.anchors/spraints
## 
## # cb.gtb.my.redcanary.co
## # ... from 'sudo plutil -p /var/root/Library/Preferences/com.carbonblack.sensor-service.plist'
## # ... from https://community.carbonblack.com/t5/Knowledge-Base/EDR-Where-are-the-sensor-files-installed-on-macOS/ta-p/85089
## table <cb> const { 35.168.216.19/32 }
## 
## # and run this:
## #  sudo dnctl pipe 1 config bw 10Kbit/s
## dummynet out proto tcp from any to <cb> pipe 1
