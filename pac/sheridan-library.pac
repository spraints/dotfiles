function FindProxyForURL(url, host) {
  if (shExpMatch(host, "*.campfirenow.com")) {
    // Enable the proxy by running this:
    //  ssh -v -N -D 127.0.0.1:5544 somehost
    // Also interesting (204.62.114.183 is campfire):
    //  lsof -nP -i @204.62.114.183:443 -i @127.0.0.1:5544
    return "SOCKS 127.0.0.1:5544; DIRECT";
  }

  return "DIRECT";
}
