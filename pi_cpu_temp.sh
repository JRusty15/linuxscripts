#!/bin/bash
TEMPRAW="$(/opt/vc/bin/vcgencmd measure_temp | egrep -o '[0-9]*\.[0-9]*')"

curl -L -X POST 'http://10.0.0.3:8086/write?db=extmonitors' \
-H 'Content-Type: text/plain' \
--data-raw "temperature,data_source=beerpicpu,data_type=celsius value=${TEMPRAW}"
