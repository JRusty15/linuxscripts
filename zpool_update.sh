#!/bin/bash
MEDIA_STATS="$(zpool list -H -o size,alloc,free,cap,health Media)"
MEDIA_IO="$(sudo zpool iostat -H Media)"
STORAGE_STATS="$(zpool list -H -o size,alloc,free,cap,health Storage)"
STORAGE_IO="$(sudo zpool iostat -H Media)"

media_split=(${MEDIA_STATS///})
MEDIA_SIZE=$(numfmt --from=auto "${media_split[0]}")
MEDIA_ALLOC=$(numfmt --from=auto "${media_split[1]}")
MEDIA_FREE=$(numfmt --from=auto "${media_split[2]}")
MEDIA_CAP=${media_split[3]::-1}
if [[ "${media_split[4]}" == "ONLINE" ]]; then
    MEDIA_HEALTH=1
else
    MEDIA_HEALTH=0
fi
media_io_split=(${MEDIA_IO///})
MEDIA_OP_READ=$(numfmt --from=auto "${media_io_split[3]}")
MEDIA_OP_WRITE=$(numfmt --from=auto "${media_io_split[4]}")
MEDIA_BW_READ=$(numfmt --from=auto "${media_io_split[5]}")
MEDIA_BW_WRITE=$(numfmt --from=auto "${media_io_split[6]}")

storage_split=(${STORAGE_STATS///})
STOR_SIZE=$(numfmt --from=auto "${storage_split[0]}")
STOR_ALLOC=$(numfmt --from=auto "${storage_split[1]}")
STOR_FREE=$(numfmt --from=auto "${storage_split[2]}")
STOR_CAP=${storage_split[3]::-1}
if [[ "${storage_split[4]}" == "ONLINE" ]]; then
    STOR_HEALTH=1
else
    STOR_HEALTH=0
fi
storage_io_split=(${STORAGE_IO///})
STOR_OP_READ=$(numfmt --from=auto "${storage_io_split[3]}")
STOR_OP_WRITE=$(numfmt --from=auto "${storage_io_split[4]}")
STOR_BW_READ=$(numfmt --from=auto "${storage_io_split[5]}")
STOR_BW_WRITE=$(numfmt --from=auto "${storage_io_split[6]}")

curl -L -X POST 'http://192.168.1.109:8086/write?db=extmonitors' \
-H 'Content-Type: text/plain' \
--data-raw "zpool,data_source=Media,data_type=size value=${MEDIA_SIZE}"

curl -L -X POST 'http://192.168.1.109:8086/write?db=extmonitors' \
-H 'Content-Type: text/plain' \
--data-raw "zpool,data_source=Media,data_type=alloc value=${MEDIA_ALLOC}"

curl -L -X POST 'http://192.168.1.109:8086/write?db=extmonitors' \
-H 'Content-Type: text/plain' \
--data-raw "zpool,data_source=Media,data_type=free value=${MEDIA_FREE}"

curl -L -X POST 'http://192.168.1.109:8086/write?db=extmonitors' \
-H 'Content-Type: text/plain' \
--data-raw "zpool,data_source=Media,data_type=capacity value=${MEDIA_CAP}"

curl -L -X POST 'http://192.168.1.109:8086/write?db=extmonitors' \
-H 'Content-Type: text/plain' \
--data-raw "zpool,data_source=Media,data_type=alloc value=${MEDIA_ALLOC}"

curl -L -X POST 'http://192.168.1.109:8086/write?db=extmonitors' \
-H 'Content-Type: text/plain' \
--data-raw "zpool,data_source=Media,data_type=health value=${MEDIA_HEALTH}"

curl -L -X POST 'http://192.168.1.109:8086/write?db=extmonitors' \
-H 'Content-Type: text/plain' \
--data-raw "zpool,data_source=Media,data_type=operations_read value=${MEDIA_OP_READ}"

curl -L -X POST 'http://192.168.1.109:8086/write?db=extmonitors' \
-H 'Content-Type: text/plain' \
--data-raw "zpool,data_source=Media,data_type=operations_write value=${MEDIA_OP_WRITE}"

curl -L -X POST 'http://192.168.1.109:8086/write?db=extmonitors' \
-H 'Content-Type: text/plain' \
--data-raw "zpool,data_source=Media,data_type=bandwidth_read value=${MEDIA_BW_READ}"

curl -L -X POST 'http://192.168.1.109:8086/write?db=extmonitors' \
-H 'Content-Type: text/plain' \
--data-raw "zpool,data_source=Media,data_type=bandwidth_write value=${MEDIA_BW_WRITE}"

curl -L -X POST 'http://192.168.1.109:8086/write?db=extmonitors' \
-H 'Content-Type: text/plain' \
--data-raw "zpool,data_source=Storage,data_type=size value=${STOR_SIZE}"

curl -L -X POST 'http://192.168.1.109:8086/write?db=extmonitors' \
-H 'Content-Type: text/plain' \
--data-raw "zpool,data_source=Storage,data_type=alloc value=${STOR_ALLOC}"

curl -L -X POST 'http://192.168.1.109:8086/write?db=extmonitors' \
-H 'Content-Type: text/plain' \
--data-raw "zpool,data_source=Storage,data_type=free value=${STOR_FREE}"

curl -L -X POST 'http://192.168.1.109:8086/write?db=extmonitors' \
-H 'Content-Type: text/plain' \
--data-raw "zpool,data_source=Storage,data_type=capacity value=${STOR_CAP}"

curl -L -X POST 'http://192.168.1.109:8086/write?db=extmonitors' \
-H 'Content-Type: text/plain' \
--data-raw "zpool,data_source=Storage,data_type=alloc value=${STOR_ALLOC}"

curl -L -X POST 'http://192.168.1.109:8086/write?db=extmonitors' \
-H 'Content-Type: text/plain' \
--data-raw "zpool,data_source=Storage,data_type=health value=${STOR_HEALTH}"

curl -L -X POST 'http://192.168.1.109:8086/write?db=extmonitors' \
-H 'Content-Type: text/plain' \
--data-raw "zpool,data_source=Storage,data_type=operations_read value=${STOR_OP_READ}"

curl -L -X POST 'http://192.168.1.109:8086/write?db=extmonitors' \
-H 'Content-Type: text/plain' \
--data-raw "zpool,data_source=Storage,data_type=operations_write value=${STOR_OP_WRITE}"

curl -L -X POST 'http://192.168.1.109:8086/write?db=extmonitors' \
-H 'Content-Type: text/plain' \
--data-raw "zpool,data_source=Storage,data_type=bandwidth_read value=${STOR_BW_READ}"

curl -L -X POST 'http://192.168.1.109:8086/write?db=extmonitors' \
-H 'Content-Type: text/plain' \
--data-raw "zpool,data_source=Storage,data_type=bandwidth_write value=${STOR_BW_WRITE}"
