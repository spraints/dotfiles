paste-crash-dump() {
  (
    dest=$HOME/crashes/`date +%s`.log
    echo Writing clipboard contents to $dest
    pbpaste > $dest
  )
}
