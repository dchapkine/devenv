#!/bin/bash

docker stop $GITLAB18EE_NAME
docker rm $GITLAB18EE_NAME
docker volume rm GITLAB18EE_conf 
docker volume rm GITLAB18EE_data 

