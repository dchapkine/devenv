docker volume create $MONGODB5_DATA
docker volume create $MONGODB5_CONF
docker run -v $MONGODB5_CONF:/tmp busybox touch /tmp/mongod.conf
docker run -d\
 -p $MONGODB5_PORT:27017\
 --name $MONGODB5_NAME\
 --restart=always\
 -v $MONGODB5_DATA:/data/db\
 -v $MONGODB5_CONF:/etc/mongo\
 -e MONGO_INITDB_ROOT_USERNAME=$MONGODB5_ADMINUSER\
 -e MONGO_INITDB_ROOT_PASSWORD=$MONGODB5_ADMINPASS\
 $MONGODB5_IMAG:$MONGODB5_VERS --config /etc/mongo/mongod.conf