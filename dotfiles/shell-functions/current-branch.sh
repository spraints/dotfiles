function current-branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/^* //'
}
