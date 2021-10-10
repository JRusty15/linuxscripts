#!/bin/bash
MEDIA_STATS="$(/sbin/zpool list -H -o size,alloc,free,cap,health Media)"
MEDIA_IO="$(/sbin/zpool iostat -H Media)"
MEDIA_COMPRESS="$(/sbin/zfs get compressratio -H Media)"
STORAGE_STATS="$(/sbin/zpool list -H -o size,alloc,free,cap,health Storage)"
STORAGE_IO="$(/sbin/zpool iostat -H Storage)"
STORAGE_COMPRESS="$(/sbin/zfs get compressratio -H Storage)"
SECURITY_STATS="$(/sbin/zpool list -H -o size,alloc,free,cap,health security)"
SECURITY_IO="$(/sbin/zpool iostat -H security)"
SECURITY_COMPRESS="$(/sbin/zfs get compressratio -H security)"

#echo "Media stats: ${MEDIA_STATS}"
#echo "Media IO: ${MEDIA_IO}"
#echo "Media compress: ${MEDIA_COMPRESS}"
#echo "Storaeg stats: ${STORAGE_STATS}"
#echo "Storage IO: ${STORAGE_IO}"
#echo "Storage compress: ${STORAGE_COMPRESS}"

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
media_compress_split=(${MEDIA_COMPRESS///})
MEDIA_COMPRESS_RATIO=$(numfmt --from=auto "${media_compress_split[2]:0:-1}")
#echo "Media CR: ${MEDIA_COMPRESS_RATIO}"

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
storage_compress_split=(${STORAGE_COMPRESS///})
STOR_COMPRESS_RATIO=$(numfmt --from=auto "${storage_compress_split[2]:0:-1}")
#echo "Storage CR: ${STOR_COMPRESS_RATIO}"

security_split=(${SECURITY_STATS///})
SEC_SIZE=$(numfmt --from=auto "${security_split[0]}")
SEC_ALLOC=$(numfmt --from=auto "${security_split[1]}")
SEC_FREE=$(numfmt --from=auto "${security_split[2]}")
SEC_CAP=${security_split[3]::-1}
if [[ "${security_split[4]}" == "ONLINE" ]]; then
    SEC_HEALTH=1
else
    SEC_HEALTH=0
fi
security_io_split=(${SECURITY_IO///})
SEC_OP_READ=$(numfmt --from=auto "${security_io_split[3]}")
SEC_OP_WRITE=$(numfmt --from=auto "${security_io_split[4]}")
SEC_BW_READ=$(numfmt --from=auto "${security_io_split[5]}")
SEC_BW_WRITE=$(numfmt --from=auto "${security_io_split[6]}")
security_compress_split=(${SECURITY_COMPRESS///})
SEC_COMPRESS_RATIO=$(numfmt --from=auto "${security_compress_split[2]:0:-1}")
#echo "Storage CR: ${SEC_COMPRESS_RATIO}"


curl -L -X POST 'http://localhost:8086/write?db=extmonitors' \
-H 'Content-Type: text/plain' \
--data-raw "zpool,data_source=Media,data_type=size value=${MEDIA_SIZE}"

curl -L -X POST 'http://localhost:8086/write?db=extmonitors' \
-H 'Content-Type: text/plain' \
--data-raw "zpool,data_source=Media,data_type=alloc value=${MEDIA_ALLOC}"

curl -L -X POST 'http://localhost:8086/write?db=extmonitors' \
-H 'Content-Type: text/plain' \
--data-raw "zpool,data_source=Media,data_type=free value=${MEDIA_FREE}"

curl -L -X POST 'http://localhost:8086/write?db=extmonitors' \
-H 'Content-Type: text/plain' \
--data-raw "zpool,data_source=Media,data_type=capacity value=${MEDIA_CAP}"

curl -L -X POST 'http://localhost:8086/write?db=extmonitors' \
-H 'Content-Type: text/plain' \
--data-raw "zpool,data_source=Media,data_type=alloc value=${MEDIA_ALLOC}"

curl -L -X POST 'http://localhost:8086/write?db=extmonitors' \
-H 'Content-Type: text/plain' \
--data-raw "zpool,data_source=Media,data_type=health value=${MEDIA_HEALTH}"

curl -L -X POST 'http://localhost:8086/write?db=extmonitors' \
-H 'Content-Type: text/plain' \
--data-raw "zpool,data_source=Media,data_type=operations_read value=${MEDIA_OP_READ}"

curl -L -X POST 'http://localhost:8086/write?db=extmonitors' \
-H 'Content-Type: text/plain' \
--data-raw "zpool,data_source=Media,data_type=operations_write value=${MEDIA_OP_WRITE}"

curl -L -X POST 'http://localhost:8086/write?db=extmonitors' \
-H 'Content-Type: text/plain' \
--data-raw "zpool,data_source=Media,data_type=bandwidth_read value=${MEDIA_BW_READ}"

curl -L -X POST 'http://localhost:8086/write?db=extmonitors' \
-H 'Content-Type: text/plain' \
--data-raw "zpool,data_source=Media,data_type=bandwidth_write value=${MEDIA_BW_WRITE}"

curl -L -X POST 'http://localhost:8086/write?db=extmonitors' \
-H 'Content-Type: text/plain' \
--data-raw "zpool,data_source=Media,data_type=compress_ratio value=${MEDIA_COMPRESS_RATIO}"

curl -L -X POST 'http://localhost:8086/write?db=extmonitors' \
-H 'Content-Type: text/plain' \
--data-raw "zpool,data_source=Storage,data_type=size value=${STOR_SIZE}"

curl -L -X POST 'http://localhost:8086/write?db=extmonitors' \
-H 'Content-Type: text/plain' \
--data-raw "zpool,data_source=Storage,data_type=alloc value=${STOR_ALLOC}"

curl -L -X POST 'http://localhost:8086/write?db=extmonitors' \
-H 'Content-Type: text/plain' \
--data-raw "zpool,data_source=Storage,data_type=free value=${STOR_FREE}"

curl -L -X POST 'http://localhost:8086/write?db=extmonitors' \
-H 'Content-Type: text/plain' \
--data-raw "zpool,data_source=Storage,data_type=capacity value=${STOR_CAP}"

curl -L -X POST 'http://localhost:8086/write?db=extmonitors' \
-H 'Content-Type: text/plain' \
--data-raw "zpool,data_source=Storage,data_type=alloc value=${STOR_ALLOC}"

curl -L -X POST 'http://localhost:8086/write?db=extmonitors' \
-H 'Content-Type: text/plain' \
--data-raw "zpool,data_source=Storage,data_type=health value=${STOR_HEALTH}"

curl -L -X POST 'http://localhost:8086/write?db=extmonitors' \
-H 'Content-Type: text/plain' \
--data-raw "zpool,data_source=Storage,data_type=operations_read value=${STOR_OP_READ}"

curl -L -X POST 'http://localhost:8086/write?db=extmonitors' \
-H 'Content-Type: text/plain' \
--data-raw "zpool,data_source=Storage,data_type=operations_write value=${STOR_OP_WRITE}"

curl -L -X POST 'http://localhost:8086/write?db=extmonitors' \
-H 'Content-Type: text/plain' \
--data-raw "zpool,data_source=Storage,data_type=bandwidth_read value=${STOR_BW_READ}"

curl -L -X POST 'http://localhost:8086/write?db=extmonitors' \
-H 'Content-Type: text/plain' \
--data-raw "zpool,data_source=Storage,data_type=bandwidth_write value=${STOR_BW_WRITE}"

curl -L -X POST 'http://localhost:8086/write?db=extmonitors' \
-H 'Content-Type: text/plain' \
--data-raw "zpool,data_source=Storage,data_type=compress_ratio value=${STOR_COMPRESS_RATIO}"

curl -L -X POST 'http://localhost:8086/write?db=extmonitors' \
-H 'Content-Type: text/plain' \
--data-raw "zpool,data_source=Security,data_type=size value=${SEC_SIZE}"

curl -L -X POST 'http://localhost:8086/write?db=extmonitors' \
-H 'Content-Type: text/plain' \
--data-raw "zpool,data_source=Security,data_type=alloc value=${SEC_ALLOC}"

curl -L -X POST 'http://localhost:8086/write?db=extmonitors' \
-H 'Content-Type: text/plain' \
--data-raw "zpool,data_source=Security,data_type=free value=${SEC_FREE}"

curl -L -X POST 'http://localhost:8086/write?db=extmonitors' \
-H 'Content-Type: text/plain' \
--data-raw "zpool,data_source=Security,data_type=capacity value=${SEC_CAP}"

curl -L -X POST 'http://localhost:8086/write?db=extmonitors' \
-H 'Content-Type: text/plain' \
--data-raw "zpool,data_source=Security,data_type=alloc value=${SEC_ALLOC}"

curl -L -X POST 'http://localhost:8086/write?db=extmonitors' \
-H 'Content-Type: text/plain' \
--data-raw "zpool,data_source=Security,data_type=health value=${SEC_HEALTH}"

curl -L -X POST 'http://localhost:8086/write?db=extmonitors' \
-H 'Content-Type: text/plain' \
--data-raw "zpool,data_source=Security,data_type=operations_read value=${SEC_OP_READ}"

curl -L -X POST 'http://localhost:8086/write?db=extmonitors' \
-H 'Content-Type: text/plain' \
--data-raw "zpool,data_source=Security,data_type=operations_write value=${SEC_OP_WRITE}"

curl -L -X POST 'http://localhost:8086/write?db=extmonitors' \
-H 'Content-Type: text/plain' \
--data-raw "zpool,data_source=Security,data_type=bandwidth_read value=${SEC_BW_READ}"

curl -L -X POST 'http://localhost:8086/write?db=extmonitors' \
-H 'Content-Type: text/plain' \
--data-raw "zpool,data_source=Security,data_type=bandwidth_write value=${SEC_BW_WRITE}"

curl -L -X POST 'http://localhost:8086/write?db=extmonitors' \
-H 'Content-Type: text/plain' \
--data-raw "zpool,data_source=Security,data_type=compress_ratio value=${SEC_COMPRESS_RATIO}"