docker volume create $VLLM_DATA
docker volume create $VLLM_CONF

docker run -d \
 --name $VLLM_NAME\
 --restart=always\
 --privileged=true \
 --shm-size=4g \
 -p $VLLM_PORT:8000 \
 -e VLLM_CPU_KVCACHE_SPACE=40 \
 -e VLLM_CPU_OMP_THREADS_BIND=0-32 \
 $VLLM_IMAG:$VLLM_VERS \
 --model=meta-llama/Llama-3.2-1B-Instruct \
 --dtype=bfloat16