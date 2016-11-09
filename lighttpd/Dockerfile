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

# install lighttpd
RUN apk add --update --no-cache \
    lighttpd lighttpd-mod_auth && \
    rm /etc/lighttpd/lighttpd.conf

# create lighttpd directory
RUN mkdir -p /etc/lighttpd /var/www && \
    chown -R www-data:www-data /etc/lighttpd /var/www

# chown timezone files
RUN touch /etc/timezone /etc/localtime && \
    chown www-data:www-data /etc/localtime /etc/timezone

# add volumes
VOLUME ["/etc/lighttpd" ,"/var/www"]

# copy run file
COPY scripts/run.sh /home/www-data/run.sh
RUN chmod +x /home/www-data/run.sh
COPY scripts/continue.sh /home/www-data/continue.sh
RUN chmod +x /home/www-data/continue.sh

ENTRYPOINT ["/home/www-data/run.sh", "su", "-m", "www-data", "-c", "/home/www-data/continue.sh /bin/bash"]