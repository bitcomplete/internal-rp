#!/bin/sh

set -e

cat << EOF > /usr/share/nginx/html/index.html
<!DOCTYPE html>
<html lang="en">
  <head>
    <title>$ROOT_DOMAIN dashboard</title>
  </head>
  <body>
    <ul>
EOF

i=1

while true; do
  service=`eval 'echo $SERVICE_'$i`
  [ -z "$service" ] && break
  cat << EOF >> /usr/share/nginx/html/index.html
      <li>
        <a href="https://$service.$ROOT_DOMAIN/">
          $service
        </a>
      </li>
EOF
  i=$((i+1))
done

cat << EOF >> /usr/share/nginx/html/index.html
    </ul>
  </body>
</html>
EOF
