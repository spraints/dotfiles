# Change to the journal directory.
journal-cd() {
  cd ~/Dropbox/journal
}

# Edit today's journal entry.
journal() {
  (
    journal-cd
    ./today
  )
}

# Search journal entries.
journal-ag() {
  (
    journal-cd
    ag "$@"
  )
}
