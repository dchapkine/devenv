docker volume create $REDIS7_DATA
docker volume create $REDIS7_CONF
docker run -v $REDIS7_CONF:/tmp busybox touch /tmp/redis.conf
docker run -d\
 -p $REDIS7_PORT:6379\
 --name $REDIS7_NAME\
 --restart=always \
 -v $REDIS7_DATA:/data\
 -v $REDIS7_CONF:/usr/local/etc/redis\
 $REDIS7_IMAG:$REDIS7_VERS