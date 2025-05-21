#!/bin/bash

docker stop gitlab
docker rm gitlab
docker volume rm GITLAB_conf 
docker volume rm GITLAB_data 

