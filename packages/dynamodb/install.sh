# make volumes
docker volume create $DYNAMODB_DATA
docker volume create $DYNAMODB_CONF

# set permissions /data
docker run -v $DYNAMODB_DATA:/data --entrypoint chmod --user root amazon/dynamodb-local 700 /data
docker run -v $DYNAMODB_DATA:/data --entrypoint chown --user root amazon/dynamodb-local -R dynamodblocal:dynamodblocal /data

# set permissions /conf
docker run -v $DYNAMODB_CONF:/conf --entrypoint chmod --user root amazon/dynamodb-local 700 /conf
docker run -v $DYNAMODB_CONF:/conf --entrypoint chown --user root amazon/dynamodb-local -R dynamodblocal:dynamodblocal /conf

# run as deamon
docker run -d\
 -p $DYNAMODB_PORT:8000\
 --name $DYNAMODB_NAME\
 --restart=always\
 -v $DYNAMODB_DATA:/data\
 -v $DYNAMODB_CONF:/conf\
 $DYNAMODB_IMAG:$DYNAMODB_VERS -jar DynamoDBLocal.jar -dbPath /data
