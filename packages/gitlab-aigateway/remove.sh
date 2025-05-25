#!/bin/bash

docker stop $GITLABAIGATEWAY_NAME
docker rm $GITLABAIGATEWAY_NAME
docker volume rm $GITLABAIGATEWAY_CONF 
docker volume rm $GITLABAIGATEWAY_DATA

