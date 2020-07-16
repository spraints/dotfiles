#!/bin/bash

fix-ssh-agent() {
  test "$1" = "--quick" && return # I used to have this in PS1, but it doesn't work from there.
  if [ "$1" = "--prompt-command" ]; then
    # If SSH_AUTH_SOCK isn't set, skip.
    # If it's set and exists, skip.
    if [ -z "$SSH_AUTH_SOCK" ] || [ -e "$SSH_AUTH_SOCK" ]; then
      return
    fi
  fi

  if _fsa___ok; then
    echo 'Your agent is ok!'
    return
  fi

  local agent="$(find-ssh-agent)"
  if [ -n "$agent" ]; then
    echo "Setting agent to $agent"
    export SSH_AUTH_SOCK=$agent
    return
  fi

  echo "No agent found."
}

find-ssh-agent() {
  if _fsa___ok; then
    echo $SSH_AUTH_SOCK
    return
  fi

  local sock
  for sock in $(_fsa___lssock); do
    if SSH_AUTH_SOCK=$sock _fsa___ok; then
      echo $sock
      return
    fi
  done
}

_fsa___ok() {
  ssh-add -l >&/dev/null
}

_fsa___lssock() {
  find /tmp/ssh-* $TMPDIR -type s -name 'agent.*' -user "$(id -un)" 2>/dev/null
  find /private/tmp -type s -name Listeners -user "$(id -un)" 2>/dev/null
}
