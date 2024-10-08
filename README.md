# SOCKS5 Proxy Setup Script for Ubuntu

This repository contains a script that helps you to setup a SOCKS5 proxy server on an Ubuntu system. The server uses `dante-server` and supports username/password authentication.

## Prerequisites

- Ubuntu system (This script was tested on Ubuntu 20.04, but should work with other versions as well).
- User with `sudo` privileges.

## Installation
Run the script
```bash
wget https://raw.githubusercontent.com/Michael1297/socks5-dante/main/socks5.sh
sudo bash socks5.sh
```

You'll be prompted for a username and password. These will be the credentials for the SOCKS5 proxy.


## Testing the Proxy
The proxy can be tested from a Windows machine using `curl`. If you don't have curl installed, it can be installed with the following command:
```bash
apt-get install curl
```

You can then test the proxy with:
```
curl --proxy socks5h://username:password@proxy_server_ip:9098 https://ifconfig.me
curl --proxy socks5://username:password@[proxy_server_ipv6]:9098 https://ifconfig.me
```
