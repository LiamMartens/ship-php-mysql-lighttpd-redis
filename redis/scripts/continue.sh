#!/bin/bash
export HOME=/home/www-data

if [ -z "$REDIS_PORT" ]; then
	export PHP_PORT=6379
fi

if [ -z "$TIMEZONE" ]; then
	export TIMEZONE='UTC'
fi

# get ip addresses and export them as environment variables
export REDIS_TCP=`getent hosts redis | awk '{ print $1 }'`

#
# set redis variables
#
# REDIS_PROTECTED_MODE -> protected-mode
#
ENV_VARS=($(env))
for VAR in "${ENV_VARS[@]}"; do
	VAR_NAME=$(echo $VAR | cut -d'=' -f 1)
	VAR_VALUE=$(echo $VAR | cut -d'=' -f 2)
	if [[ "$VAR_NAME" =~ "REDIS_"* ]] && [[ "$VAR_NAME" != "REDIS_PORT" ]]; then
		REDIS_SETTING=$(echo $VAR_NAME | cut -d'_' -f 2-)
		REDIS_SETTING=$(echo $REDIS_SETTING | awk '{print tolower($0)}')
		REDIS_SETTING=$(echo $REDIS_SETTING | perl -pe "s/_/-/")
		perl -pi -e "s/^$REDIS_SETTING\s+.*/$REDIS_SETTING $VAR_VALUE/gi" /etc/redis/redis.conf
	fi
done

# set timezone
cat /usr/share/zoneinfo/$TIMEZONE > /etc/localtime
echo $TIMEZONE > /etc/timezone

# set redis listen port
perl -pi -e "s/bind\s+(.+)/bind $REDIS_TCP/gi" /etc/redis/redis.conf

# set redis listen port
perl -pi -e "s/port\s+(.+)/port $REDIS_PORT/gi" /etc/redis/redis.conf

echo "Starting redis on $REDIS_PORT"
redis-server /etc/redis/redis.conf --loglevel verbose

exec "$@"