#!/bin/bash
GPUFAN="$(nvidia-smi --query-gpu=fan.speed --format=csv,noheader,nounits)"
GPUTEMP="$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits)"
GPUTOTALMEM="$(nvidia-smi --query-gpu=memory.total --format=csv,noheader,nounits)"
GPUFREEMEM="$(nvidia-smi --query-gpu=memory.free --format=csv,noheader,nounits)"
GPUUSEDMEM="$(nvidia-smi --query-gpu=memory.used --format=csv,noheader,nounits)"

curl -L -X POST 'http://192.168.1.109:8086/write?db=extmonitors' \
        -H 'Content-Type: text/plain' \
        --data-raw "temperature,data_source=gpu,data_type=celsius value=${GPUTEMP}"

curl -L -X POST 'http://192.168.1.109:8086/write?db=extmonitors' \
        -H 'Content-Type: text/plain' \
        --data-raw "fan,data_source=gpu,data_type=percent value=${GPUFAN}"

curl -L -X POST 'http://192.168.1.109:8086/write?db=extmonitors' \
        -H 'Content-Type: text/plain' \
        --data-raw "memory,data_source=gpu,data_type=total value=${GPUTOTALMEM}"

curl -L -X POST 'http://192.168.1.109:8086/write?db=extmonitors' \
        -H 'Content-Type: text/plain' \
        --data-raw "memory,data_source=gpu,data_type=free value=${GPUFREEMEM}"

curl -L -X POST 'http://192.168.1.109:8086/write?db=extmonitors' \
        -H 'Content-Type: text/plain' \
        --data-raw "memory,data_source=gpu,data_type=used value=${GPUUSEDMEM}"
