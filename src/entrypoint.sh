#!/bin/bash
set -e

# Setup runtime webdavd user for nginx
USER_ID=${USER_ID:-1101}
GROUP_ID=${GROUP_ID:-1101}

echo "Starting with uid:gid ${USER_ID}:${GROUP_ID}"


addgroup \
  --gid "${GROUP_ID}" \
  webdavd

adduser \
  --disabled-password \
  --gecos "" \
  --ingroup webdavd \
  --no-create-home \
  --uid "${USER_ID}" \
  webdavd

# Create webdav http user
if [ -n "${DAV_USER}" ]; then
  echo "Creating htpasswd user for ${DAV_USER}"
  /usr/bin/htpasswd -bc5 /webdavd/htpasswd/htpasswd "${DAV_USER}" "${DAV_PASSWORD}"
  chmod 0440 /webdavd/htpasswd/htpasswd
  chown root:webdavd /webdavd/htpasswd/htpasswd
fi

if [ ! -d /webdavd/shared ]; then
  echo "/webdavd/shared directory does not exist!"
  echo "Please bind mount to that directory"
  exit 101
fi

if [ ! -f /webdavd/htpasswd/htpasswd ]; then
  echo "/webdavd/htpasswd/htpasswd file does not exist!"
  echo "Either provide DAV_USER / DAV_PASSWORD envvars,"
  echo "or mount in your own htpasswd file"
  exit 102
fi

# Fixup runtime dir perms
chown -R webdavd:webdavd \
    /run \
    /webdavd/htpasswd/htpasswd \
    /var/lib/nginx \
    /var/log/nginx \

chmod a+w /dev/stdout /dev/stderr

# Start nginx
/usr/local/bin/gosu webdavd /usr/sbin/nginx -g 'daemon off;'
