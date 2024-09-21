FROM docker.io/alpine:3.20

# Ensure we're root
USER root

# Install packages and remove default server definition
RUN set -exu \
  && apk add --no-cache \
      curl \
      nginx \
      php83 \
      php83-ctype \
      php83-curl \
      php83-dom \
      php83-fileinfo \
      php83-fpm \
      php83-gd \
      php83-intl \
      php83-mbstring \
      php83-mysqli \
      php83-opcache \
      php83-openssl \
      php83-phar \
      php83-session \
      php83-tokenizer \
      php83-xml \
      php83-xmlreader \
      php83-xmlwriter \
      supervisor

RUN set -exu \
  && addgroup \
    --gid 1101 \
    webdav \
  && adduser \
    --disabled-password \
    --gecos "" \
    --ingroup webdav \
    --no-create-home \
    --uid 1101 \
    webdav \
  && mkdir -p /webdav

# Configure nginx
COPY src/nginx-default.conf /etc/nginx/conf.d/default.conf

COPY src/fancyindex /fancyindex

# Configure php-fpm
COPY src/fpm-pool.conf /etc/php83/php-fpm.d/www.conf
COPY src/php.ini /etc/php83/conf.d/custom.ini

# Configure supervisord
COPY src/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Make sure files/folders needed by the processes are accessable when they run under the webdav user
# RUN chown -R webdav:webdav /var/www/html /run /var/lib/nginx /var/log/nginx

# Expose the port nginx is reachable on
EXPOSE 8080

# Let supervisord start nginx & php-fpm
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

# Configure a healthcheck to validate that everything is up&running
HEALTHCHECK --timeout=10s CMD curl --silent --fail http://127.0.0.1:8080/fpm-ping || exit 1
