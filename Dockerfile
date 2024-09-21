FROM docker.io/alpine:3.20

# Ensure we're root
USER root

# Install packages and remove default server definition
RUN set -exu \
  && apk add --no-cache \
      bash \
      apache2-utils \
      nginx \
      nginx-mod-http-fancyindex \
      nginx-mod-http-dav-ext

RUN set -exu \
  && addgroup \
    --gid 1101 \
    webdavd \
  && adduser \
    --disabled-password \
    --gecos "" \
    --ingroup webdavd \
    --no-create-home \
    --uid 1101 \
    webdavd \
  && mkdir -p /webdavd/shared /webdavd/htpasswd

# Configure nginx
COPY src/nginx.conf /etc/nginx/nginx.conf
COPY src/nginx-default.conf /etc/nginx/conf.d/default.conf
COPY src/nginx-fancyindex-theme/theme /var/lib/nginx/html/fi
COPY src/entrypoint.sh /webdavd/entrypoint.sh

# Expose the port nginx is reachable on
EXPOSE 8080

# Fix permissions for running as webdavd user
RUN set -exu \
  && chown -R webdavd:webdavd \
    /run \
    /webdavd/htpasswd \
    /var/lib/nginx \
    /var/log/nginx

# Switch to webdavd user
USER webdavd

# Create webdav user and start nginx
CMD ["/bin/bash", "/entrypoint.sh"]
