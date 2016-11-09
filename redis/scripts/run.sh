#!/bin/bash
chown -R www-data:www-data /etc/redis /var/log/redis /var/lib/redis /var/www
exec "$@"