#!/bin/bash
for i in 1 2 3 4 5
do
	FANSPEED="$(cat /sys/devices/platform/nct6775.656/hwmon/hwmon0/fan${i}_input)"

	curl -L -X POST 'http://192.168.1.109:8086/write?db=extmonitors' \
	-H 'Content-Type: text/plain' \
	--data-raw "speed,data_source=fan,data_type=rpm,instance=${i} value=${FANSPEED}"
done
