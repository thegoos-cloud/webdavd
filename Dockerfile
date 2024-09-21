FROM docker.io/alpine:3.20

# Ensure we're root
USER root

# Install packages
RUN set -exu \
  && apk add --no-cache \
      bash \
      apache2-utils \
      nginx \
      nginx-mod-http-fancyindex \
      nginx-mod-http-dav-ext \
  && mkdir -p /webdavd/htpasswd

# Configure nginx
COPY src/nginx.conf /etc/nginx/nginx.conf
COPY src/nginx-default.conf /etc/nginx/conf.d/default.conf
COPY src/fi-theme /var/lib/nginx/html/fi
COPY src/entrypoint.sh /webdavd/entrypoint.sh

# Install gosu
COPY --from=docker.io/tianon/gosu /gosu /usr/local/bin/

# Expose nginx port
EXPOSE 8080

# Create webdav user and start nginx
ENTRYPOINT ["/bin/bash"]
CMD ["/webdavd/entrypoint.sh"]
