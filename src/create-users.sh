#!/bin/bash
set -e

if [ ! -z "$DAVUSER" ]; then
  htpasswd -bcd /etc/nginx/.htpasswd $DAVUSER $DAVPASSWORD
fi
