ghcs() {
  (
    . ~/.github-token
    export GITHUB_TOKEN
    /usr/local/bin/ghcs "$@"
  )
}
