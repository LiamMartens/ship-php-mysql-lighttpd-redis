#!/bin/bash
chown -R mysql:mysql /var/lib/mysql /etc/mysql
exec "$@"