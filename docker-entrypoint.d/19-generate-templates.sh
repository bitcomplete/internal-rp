#!/bin/sh

set -e

i=1
mkdir -p /etc/nginx/templates

cp templates/root.conf.template /etc/nginx/templates/

while true; do
  service=`eval 'echo $SERVICE_'$i`
  [ -z "$service" ] && break
  backend=`eval 'echo $BACKEND_'$i`
  if [ -z "$backend" ]; then
    sed -e "s/SERVICE/SERVICE_$i/" \
      -e "s/BUCKET_PREFIX/BUCKET_PREFIX_$i/" \
      templates/static.conf.template > /etc/nginx/templates/${service}.conf.template
  else
    sed -e "s/SERVICE/SERVICE_$i/" \
      -e "s/BACKEND/BACKEND_$i/" \
      templates/proxy.conf.template > /etc/nginx/templates/${service}.conf.template
  fi
  i=$((i+1))
done
