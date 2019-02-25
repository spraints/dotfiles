#!/bin/bash

fix-ssh-agent() {
  cmd=_fsa___link
  quick=false
  for arg; do
    case "$arg" in
      --clear|--clean)
        cmd=_fsa___rmlinks ;;
      --quick)
        if _fsa___quick_check_ssh_auth_sock; then
          exit 0
        fi
        quick=true ;;
      *)
        cat <<USAGE
Usage: fix-ssh-agent [--clean] [--quick]
  --clean        Remove ssh-agent symlinks
  --quick        Don't output anything, only check that key exists
USAGE
        exit 1 ;;
    esac
  done

  $cmd
}

_fsa___link() {
  ssh-add -l >&/dev/null && _fsa___ok your ssh agent looks ok
  test -n "$SSH_AUTH_SOCK" || _fsa___die error: SSH_AUTH_SOCK is not set.
  _fsa___peel_ssh_auth_sock
  test -e "$SSH_AUTH_SOCK" && _fsa___die error: $SSH_AUTH_SOCK already exists, but it does not appear to be working correctly.

  sockets=$(_fsa___lssock | wc -l)
  case "$sockets" in
    0)
      _fsa___die error: no sockets were found in '/tmp/ssh*' ;;
    1)
      : ;;
    *)
      _fsa___die error: need one, but found $sockets sockets in '/tmp/ssh*' ;;
  esac

  socket=$(_fsa___lssock)
  sockdir=$(dirname $SSH_AUTH_SOCK)
  set -x
  mkdir -p $sockdir || exit 1
  ln -s $socket $SSH_AUTH_SOCK || exit 1
  ssh-add -l
}

_fsa___rmlinks() {
  for link in $(_fsa___lssocklink); do
    echo Remove $link
    rm -f $link
    rmdir $(dirname $link)
  done
  _fsa___link
}

_fsa___lssocklink() {
  find /tmp/ssh-* -type l -name 'agent.*'
}

_fsa___lssock() {
  find /tmp/ssh-* -type s -name 'agent.*' | head -n 1
}

_fsa___ok() {
  $quick || echo "$@"
  exit 0
}

_fsa___die() {
  $quick || echo "$@"
  exit 1
}

_fsa___peel_ssh_auth_sock() {
  while [ -L "$SSH_AUTH_SOCK" ]; do
    export SSH_AUTH_SOCK=$(readlink $SSH_AUTH_SOCK)
  done
}

_fsa___quick_check_ssh_auth_sock() {
  test -e "$SSH_AUTH_SOCK"
}

