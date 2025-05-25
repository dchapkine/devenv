#!/bin/bash

docker stop $VLLM_NAME
docker rm $VLLM_NAME
docker volume rm $VLLM_CONF 
docker volume rm $VLLM_DATA 

