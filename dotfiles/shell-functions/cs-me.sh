cs-me() {
  local root="$(git rev-parse --show-toplevel)"
  local name="$(basename "$root")"
  local owner="$(basename "$(dirname "$root")")"
  local branch="$(current-branch)"
  (set -x; gh cs create --repo "${owner}/${name}" --branch "${branch}")
}
