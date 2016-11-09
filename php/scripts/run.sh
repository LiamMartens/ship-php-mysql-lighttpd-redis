#!/bin/bash
chown -R www-data:www-data /var/www /etc/php7 /var/log/php7
exec "$@"