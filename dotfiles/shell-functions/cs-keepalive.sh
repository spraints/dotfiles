cs-keepalive() {
  if [ $# -ne 1 ]; then
    echo Usage: cs-keepalive CODESPACE_ID
    gh cs list
    return
  fi
  while echo date | gh cs ssh -c "$1"; do
    sleep 120
    echo pinging codespace "$1" ...
  done
}

# ok: zsh
