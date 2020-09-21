#!/bin/bash
TEMPRAW="$(cat /sys/devices/platform/nct6775.656/hwmon/hwmon0/temp2_input)"
TEMP="$(expr $TEMPRAW / 1000)"

curl -L -X POST 'http://localhost:8086/write?db=extmonitors' \
-H 'Content-Type: text/plain' \
--data-raw "temperature,data_source=cpu,data_type=celsius value=${TEMP}"
