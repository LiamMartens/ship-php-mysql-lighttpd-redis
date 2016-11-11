FROM alpine:edge
MAINTAINER Liam Martens (hi@liammartens.com)

# add www-data user
RUN adduser -D www-data

# run updates
RUN apk update && apk upgrade

# add packages
RUN apk add --update --no-cache \
    tzdata bash wget curl pwgen \
    sudo nano htop perl

# install redis
RUN apk add --update --no-cache redis

# create php directory
RUN mkdir -p /etc/redis /var/log/redis /var/run/redis /var/www /var/lib/redis && \
    chown -R www-data:www-data /etc/redis /var/log/redis /var/run/redis /var/www /var/lib/redis

# chown timezone files
RUN touch /etc/timezone /etc/localtime && \
    chown www-data:www-data /etc/localtime /etc/timezone

# set volume
VOLUME ["/etc/redis", "/var/log/redis", "/var/lib/redis", "/var/www"]

# copy run file
COPY scripts/run.sh /home/www-data/run.sh
RUN chmod +x /home/www-data/run.sh
COPY scripts/continue.sh /home/www-data/continue.sh
RUN chmod +x /home/www-data/continue.sh

ENTRYPOINT ["/home/www-data/run.sh", "su", "-m", "www-data", "-c", "/home/www-data/continue.sh /bin/bash"]