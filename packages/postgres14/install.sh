docker volume create $POSTGRES14_DATA
docker volume create $POSTGRES14_CONF
#docker run -v $POSTGRES14_CONF:/tmp busybox touch /tmp/postgresql.conf
#docker run -v $POSTGRES14_DATA:/tmp busybox chown -R postgres:postgres /tmp 
# extract postgres config
#docker run -i --rm $POSTGRES14_IMAG:$POSTGRES14_VERS cat /usr/share/postgresql/postgresql.conf.sample > /tmp/postgres.conf

docker run -d\
 -p $POSTGRES14_PORT:5432\
 --name $POSTGRES14_NAME\
 --restart=always \
 --user "postgres:postgres" \
 -v $POSTGRES14_DATA:/var/lib/postgresql/data\
 -e PGDATA=/var/lib/postgresql/data/pgdata\
 -e POSTGRES_USER=$POSTGRES14_ADMINUSER\
 -e POSTGRES_PASSWORD=$POSTGRES14_ADMINPASS\
 $POSTGRES14_IMAG:$POSTGRES14_VERS

#-v $POSTGRES14_CONF:/usr/share/postgresql\
 