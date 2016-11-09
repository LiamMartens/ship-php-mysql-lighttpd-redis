#!/bin/bash
chown -R www-data:www-data /var/www /etc/lighttpd
exec "$@"