# Docker Image for webdav server

Very basic nginx-as-webdavd+fancyindex container.

## Envvar Parameters

```bash
# (Optional) Automatically create user at startup:
DAV_USER="areallycooluser"
DAV_PASSWORD="areallygoodpassword"

# UID/GID to run as
USER_ID="1101"
GROUP_ID="1101"
```

## Volumes

|Mount                          | Purpose
|---                            | ---
|/webdavd/shared                | folder to share
|/webdavd/htpasswd/htpasswd     | override generated htpasswd
|/var/lib/nginx/html/fi/        | override fancyindex theme
|/webdavd/entrypoint.sh         | override entrypoint script
|/etc/nginx/nginx.conf          | override nginx global conf
|/etc/nginx/conf.d/default.conf | override nginx site conf

## Ports

`8080/tcp/http`
