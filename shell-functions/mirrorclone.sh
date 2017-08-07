mirrorclone() {
  (
  set -e
  usage="Usage: mirrorclone OWNER/NAME"
  if [ $# -ne 1 ] || [ -z "$1" ] || [ "$(echo "$1" | cut -c 1)" = "-" ] || [ "$(echo "$1" | cut -d / -f 1)" = "$1" ] || [ "$(echo "$1" | cut -d / -f 1,2)" != "$1" ]; then
    echo $usage
    return
  fi
  NWO="$(echo "$1" | sed -e 's/.git$//')"
  GITHUB_URL="git@github.com:$NWO"
  MIRROR="$HOME/.git-mirrors/github.com/$NWO.git"
  WORKDIR="$HOME/$NWO"
  if [ -d "$MIRROR" ]; then
    echo mirror "$MIRROR" already exists, not overwriting
    return
  elif [ -d "$WORKDIR" ]; then
    echo work dir "$WORKDIR" already exists, not overwriting
    return
  fi
  set -x
  git clone --mirror "$GITHUB_URL" "$MIRROR"
  git clone --shared "$MIRROR" "$WORKDIR"
  rm -rf "$WORKDIR/.git/objects"
  ln -s "$MIRROR/objects" "$WORKDIR/.git/objects"
  git -C "$WORKDIR" remote set-url origin "$GITHUB_URL"
  git -C "$WORKDIR" --no-pager show
  )
}
