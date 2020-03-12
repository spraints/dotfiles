#!/bin/bash

fix-ssh-agent() {
  cmd=_fsa___link
  _fsa_quick=false
  for arg; do
    case "$arg" in
      --clear|--clean)
        cmd=_fsa___rmlinks ;;
      --quick)
        if _fsa___quick_check_ssh_auth_sock; then
          return 0
        fi
        _fsa_quick=true ;;
      *)
        cat <<USAGE
Usage: fix-ssh-agent [--clean] [--quick]
  --clean        Remove ssh-agent symlinks
  --quick        Don't output anything, only check that key exists
USAGE
        return 1 ;;
    esac
  done

  $cmd
}

_fsa___link() {
  if ssh-add -l >&/dev/null; then
    _fsa___msg your ssh agent looks ok
    return 0
  fi
  if ! test -n "$SSH_AUTH_SOCK"; then
    _fsa___err SSH_AUTH_SOCK is not set.
    return 1
  fi
  _fsa___peel_ssh_auth_sock
  if test -e "$SSH_AUTH_SOCK"; then
    _fsa___err $SSH_AUTH_SOCK already exists, but it does not appear to be working correctly.
    return 1
  fi

  sockets=$(_fsa___lssock | wc -l)
  case "$sockets" in
    0)
      _fsa___err no sockets were found in '/tmp/ssh*'
      return 1 ;;
    1)
      : ;;
    *)
      _fsa___err need one, but found $sockets sockets in '/tmp/ssh*'
      return 1 ;;
  esac

  socket=$(_fsa___lssock)
  sockdir=$(dirname $SSH_AUTH_SOCK)
  mkdir -p $sockdir || return 1
  ln -s $socket $SSH_AUTH_SOCK || return 1
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

_fsa___msg() {
  $_fsa_quick || echo "$@"
}

_fsa___err() {
  _fsa___msg error: "$@"
}

_fsa___peel_ssh_auth_sock() {
  while [ -L "$SSH_AUTH_SOCK" ]; do
    export SSH_AUTH_SOCK=$(readlink $SSH_AUTH_SOCK)
  done
}

_fsa___quick_check_ssh_auth_sock() {
  test -e "$SSH_AUTH_SOCK"
}

