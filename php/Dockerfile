FROM alpine:edge
MAINTAINER Liam Martens (hi@liammartens.com)

# add testing branch
RUN echo @testing http://dl-cdn.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories

# add www-data user
RUN adduser -D www-data

# run updates
RUN apk update && apk upgrade

# add packages
RUN apk add --update --no-cache \
    tzdata bash wget curl pwgen \
    sudo nano htop perl

# install php 7
ENV PHPV=7
RUN apk add --update --no-cache \
    php$PHPV-mcrypt \
    php$PHPV-soap \
    php$PHPV-openssl \
    php$PHPV-gmp \
    php$PHPV-pdo_odbc \
    php$PHPV-json \
    php$PHPV-dom \
    php$PHPV-pdo \
    php$PHPV-zip \
    php$PHPV-mysqli \
    php$PHPV-sqlite3 \
    php$PHPV-pdo_pgsql \
    php$PHPV-bcmath \
    php$PHPV-opcache \
    php$PHPV-intl \
    php$PHPV-mbstring \
    php$PHPV-sockets \
    php$PHPV-zlib \
    php$PHPV-xml \
    php$PHPV-session \
    php$PHPV-pcntl \
    php$PHPV-gd \
    php$PHPV-odbc \
    php$PHPV-pdo_mysql \
    php$PHPV-pdo_sqlite \
    php$PHPV-gettext \
    php$PHPV-xmlreader \
    php$PHPV-xmlrpc \
    php$PHPV-bz2 \
    php$PHPV-iconv \
    php$PHPV-pdo_dblib \
    php$PHPV-curl \
    php$PHPV-ctype \
    php$PHPV-pear \
    php$PHPV-common \
    php$PHPV-redis@testing \
    php$PHPV-fpm

# create php directory
RUN mkdir -p /etc/php7 /var/log/php7 /usr/lib/php7 /var/www && \
    chown -R www-data:www-data /etc/php7 /var/log/php7 /usr/lib/php7 /var/www

# chown timezone files
RUN touch /etc/timezone /etc/localtime && \
    chown www-data:www-data /etc/localtime /etc/timezone

# set volume
VOLUME ["/etc/php7", "/var/log/php7", "/var/www"]

# copy run file
COPY scripts/run.sh /home/www-data/run.sh
RUN chmod +x /home/www-data/run.sh

# set workdir and user
USER www-data
WORKDIR /home/www-data

ENTRYPOINT ["/home/www-data/run.sh"]
CMD ["/bin/bash"]