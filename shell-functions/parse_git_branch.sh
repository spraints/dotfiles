function parse_git_branch {
  local branch="$(current-branch)"
  test -n "$branch" && printf " [%s]" "$(current-branch)"
}
