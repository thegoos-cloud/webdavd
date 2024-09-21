#!/bin/bash
set -e

if [ ! -z "$DAVUSER" ]; then
  htpasswd -bcd /tmp/htpasswd $DAVUSER $DAVPASSWORD
fi
