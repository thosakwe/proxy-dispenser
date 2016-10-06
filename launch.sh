#!/usr/bin/env bash
cd /var/www
rm -rf build
/usr/lib/dart/bin/pub build --mode=release --output=build
ANGEL_ENV=production /usr/bin/dart /var/www/bin/server.dart