import json
import os
import requests

stream = os.popen('speedtest-cli --bytes --json')
output = stream.read()
data = json.loads(output)

download_speed = data["download"]
upload_speed = data["upload"]
ping = data["ping"]

print("download speed {}".format(download_speed))
print("upload speed {}".format(upload_speed))
print("ping {}".format(ping))

base_url = "http://localhost:8086/write?db=extmonitors"
headers = {'Content-Type': 'text/plain'}
download_data = "isp,data_type=download value={}".format(download_speed)
upload_data = "isp,data_type=upload value={}".format(upload_speed)
ping_data = "isp,data_type=ping value={}".format(ping)

print(download_data)
print(upload_data)
print(ping_data)

dlresponse = requests.post(base_url, headers=headers, data=download_data)
print("Download: {}".format(dlresponse.status_code))

upresponse = requests.post(base_url, headers=headers, data=upload_data)
print("Upload: {}".format(upresponse.status_code))

presponse = requests.post(base_url, headers=headers, data=ping_data)
print("Ping: {}".format(presponse.status_code))
