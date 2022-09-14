docker volume create $NEO4J4CE_DATA
docker volume create $NEO4J4CE_CONF
docker run -v $NEO4J4CE_CONF:/tmp busybox touch /tmp/neo4j.conf
docker run -d\
 -p $NEO4J4CE_PORT:7474\
 -p $NEO4J4CE_PORT2:7687\
 --name $NEO4J4CE_NAME\
 --restart=always \
 -v $NEO4J4CE_DATA:/data\
 -v $NEO4J4CE_CONF:/conf\
 --env=NEO4J_AUTH=$NEO4J4CE_ADMINUSER/$NEO4J4CE_ADMINPASS\
 $NEO4J4CE_IMAG:$NEO4J4CE_VERS