docker volume create $MYSQL8_DATA
docker volume create $MYSQL8_CONF
docker run -v $MYSQL8_CONF:/tmp busybox touch /tmp/custom.cnf
docker run -d\
 -p $MYSQL8_PORT:3306\
 --name $MYSQL8_NAME\
 --restart=always \
 -v $MYSQL8_DATA:/var/lib/mysql\
 -v $MYSQL8_CONF:/etc/mysql/conf.d\
 -e MYSQL_ROOT_PASSWORD=$MYSQL8_ADMINPASS\
 $MYSQL8_IMAG:$MYSQL8_VERS