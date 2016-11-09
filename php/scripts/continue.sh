#!/bin/bash
export HOME=/home/www-data

if [ -z "$PHP_PORT" ]; then
	export PHP_PORT=9000
fi

if [ -z "$TIMEZONE" ]; then
	export TIMEZONE='UTC'
fi

# get ip addresses and export them as environment variables
export PHP_TCP=`getent hosts php | awk '{ print $1 }'`
export REDIS_TCP=`getent hosts redis | awk '{ print $1 }'`

# set timezone
cat /usr/share/zoneinfo/$TIMEZONE > /etc/localtime
echo $TIMEZONE > /etc/timezone

#
# set php variables
#
# PHP_MEMORY_LIMIT -> memory_limit
# PHP_ZLIB__OUTPUT_COMPRESSION -> zlib.output_compression
#
ENV_VARS=($(env))
for VAR in "${ENV_VARS[@]}"; do
	VAR_NAME=$(echo $VAR | cut -d'=' -f 1)
	VAR_VALUE=$(echo $VAR | cut -d'=' -f 2)
	if [[ "$VAR_NAME" =~ "PHP_"* ]] && [[ "$VAR_NAME" != "PHP_PORT" ]]; then
		PHP_SETTING=$(echo $VAR_NAME | cut -d'_' -f 2-)
		PHP_SETTING=$(echo $PHP_SETTING | awk '{print tolower($0)}')
		PHP_SETTING=$(echo $PHP_SETTING | perl -pe "s/__/./")
		perl -pi -e "s/^$PHP_SETTING\s*=\s*.*/$PHP_SETTING = $VAR_VALUE/gi" /etc/php7/php.ini
	fi
done

# set php listen port
perl -pi -e "s/listen\s*=\s*(.+):.+/listen = $PHP_TCP:$PHP_PORT/gi" /etc/php7/php-fpm.d/www.conf

# set timezone
perl -pi -e "s/;*date.timezone\s*=.*/date.timezone = $TIMEZONE/gi" /etc/php7/php.ini

echo "Starting PHP FPM on $PHP_PORT"
php-fpm7

exec "$@"