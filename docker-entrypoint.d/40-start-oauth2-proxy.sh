#!/bin/sh

set -e

export OAUTH2_PROXY_COOKIE_DOMAINS=".${ROOT_DOMAIN}"
export OAUTH2_PROXY_WHITELIST_DOMAINS=".${ROOT_DOMAIN}"

nohup oauth2-proxy &
pid=$!

while [ `curl -s -o /dev/null -w %{http_code} http://127.0.0.1:4180/ping` -eq '000' ]; do
  if [ ! -e /proc/$pid ]; then
    echo "oauth2-proxy exited"
    exit 1
  fi
  sleep 0.1
done

nohup gcsproxy -b 127.0.0.1:4181 -v &
