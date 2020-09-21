#!/bin/bash
DATA="$(speedtest-cli --bytes --csv --csv-delimiter ';')"
PING=""
DOWNLOAD=""
UPLOAD=""
IP=""

#7 = ping
#8 = download speed in bytes
#9 = upload speed in bytes
#10 = public IP address

arrData=(${DATA//;/ })


PING=${arrData[7]}
DOWNLOAD=${arrData[8]}
UPLOAD=${arrData[9]}
IP=${arrData[10]}

curl -L -X POST 'http://localhost:8086/write?db=extmonitors' \
        -H 'Content-Type: text/plain' \
        --data-raw "isp,data_type=ping value=${PING}"

curl -L -X POST 'http://localhost:8086/write?db=extmonitors' \
        -H 'Content-Type: text/plain' \
        --data-raw "isp,data_type=download value=${DOWNLOAD}"

curl -L -X POST 'http://localhost:8086/write?db=extmonitors' \
        -H 'Content-Type: text/plain' \
        --data-raw "isp,data_type=upload value=${UPLOAD}"


