docker volume create $MINIO_DATA
#docker volume create $MINIO_CONF
#docker run -v $MINIO_CONF:/tmp busybox touch /tmp/mongod.conf
docker run -d\
 -p $MINIO_PORT_API:9000\
 -p $MINIO_PORT_GUI:9090\
 --name $MINIO_NAME\
 --restart=always\
 -v $MINIO_DATA:/data\
 -e MINIO_ROOT_USER=$MINIO_ADMINUSER\
 -e MINIO_ROOT_PASSWORD=$MINIO_ADMINPASS\
 $MINIO_IMAG:$MINIO_VERS server /data --console-address ":9090"