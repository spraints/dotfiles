function FindProxyForURL(url, host) {
  if (host == "github.localhost" || shExpMatch(host, "*.github.localhost")) {
    // Enable the proxy by running this:
    //  ssh -D 127.0.0.1:5555 nachos
    return "SOCKS 127.0.0.1:5555; DIRECT";
  }

  return "DIRECT";
}
