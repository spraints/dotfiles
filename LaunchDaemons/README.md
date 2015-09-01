# system services

    for f in *.plist; do
      sudo cp $f /Library/LaunchDaemons/
      sudo launchctl load /Library/LaunchDaemons/$f
    done
