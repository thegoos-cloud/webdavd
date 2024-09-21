#!/bin/bash
set -e

if [ ! -z "$DAVUSER" ]; then
  /usr/bin/htpasswd -bcd /webdavd/htpasswd/htpasswd $DAVUSER $DAVPASSWORD
fi
