function FindProxyForURL(url, host) {
  if (shExpMatch(host, "*.campfirenow.com")) {
    // Enable the proxy by running this:
    //  ssh -D 127.0.0.1:5544 -N somehost
    return "SOCKS 127.0.0.1:5544; DIRECT";
  }

  return "DIRECT";
}
