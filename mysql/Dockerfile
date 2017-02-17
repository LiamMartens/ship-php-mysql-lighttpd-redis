FROM alpine:edge
MAINTAINER Liam Martens (hi@liammartens.com)

# add mysql user
RUN adduser -D mysql

# run updates
RUN apk update && apk upgrade

# add packages
RUN apk add tzdata bash wget curl pwgen sudo nano htop perl

# add mysql
RUN apk add mariadb mariadb-client

# purge and re-create /var/lib/mysql with appropriate ownership
RUN mkdir -p /var/lib/mysql /run/mysqld && \
    chown -R mysql:mysql /var/lib/mysql /run/mysqld

# chown timezone files
RUN touch /etc/timezone /etc/localtime && \
    chown mysql:mysql /etc/localtime /etc/timezone

# set volume
VOLUME ["/var/lib/mysql", "/etc/mysql"]

# copy run file
COPY scripts/run.sh /home/mysql/run.sh
RUN chmod +x /home/mysql/run.sh
COPY scripts/continue.sh /home/mysql/continue.sh
RUN chmod +x /home/mysql/continue.sh

ENTRYPOINT ["/home/mysql/run.sh", "su", "-m", "mysql", "-c", "/home/mysql/continue.sh /bin/bash"]