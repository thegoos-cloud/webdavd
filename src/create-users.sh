#!/bin/bash
set -e

if [ ! -z "$DAVUSER" ]; then
  htpasswd -bcd /webdavd/htpasswd/htpasswd $DAVUSER $DAVPASSWORD
fi
