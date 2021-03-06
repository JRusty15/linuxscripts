import datetime;
import os.path
from os import path
import requests

storage_log_file_name = 'rsync_storage.log'
media_log_file_name = 'rsync_media.log'
log_file_path = '/home/jeff/Documents/rsynclogs/'
log_file_archive = log_file_path + 'archive/'

def process_rsync_log(log_file_name):
	if log_file_name == storage_log_file_name:
		type = "Storage"
	elif log_file_name == media_log_file_name:
		type = "Media"
	
	# Check if rsync log file exists
	if not path.exists(log_file_path + log_file_name):
		print("File not found")
		return

	# If log file exists, parse data
	print("File IS found")
	file_count = 0
	dir_count = 0
	with open(log_file_path + log_file_name) as openfileobject:
		for line in openfileobject:
			date_time = line[0:19]
			index = line.find(']')
			message = line[index+2:]
			
			# First line of log file
			if message.find('building file list') > -1:
				start_date_time = date_time
			# Transmit bytes
			elif message.find('bytes/sec') > -1:
				data = message.split()
				sent_bytes = data[1].replace(',','')
				recv_bytes = data[4].replace(',','')
				rate = data[6].replace(',','')
			#  Total size
			elif message.find('total size') > -1:
				end_date_time = date_time
				data = message.split()
				total_size = data[3].replace(',','')
				speedup = data[6].replace(',','')
			elif message.find('>f+++++++++'):
				file_count = file_count + 1
			elif message.find('cd+++++++++'):
				dir_count = dir_count + 1

	# Calculate minutes elapsed
	start_datetime_object = datetime.datetime.strptime(start_date_time, '%Y/%m/%d %H:%M:%S')
	end_datetime_object = datetime.datetime.strptime(end_date_time, '%Y/%m/%d %H:%M:%S')
	elapsed_time = end_datetime_object - start_datetime_object
	minutes_elapsed = elapsed_time.total_seconds() / 60

	print("Sent: {}".format(sent_bytes))
	print("Recv: {}".format(recv_bytes))
	print("Rate: {}".format(rate))
	print("Size: {}".format(total_size))
	print("Speedup: {}".format(speedup))
	print("Time: {}".format(minutes_elapsed))
	print("Files: {}".format(file_count))
	print("Dirs: {}".format(dir_count))

	# Configure API calls to influx DB
	base_url = "http://localhost:8086/write?db=extmonitors"
	headers = {'Content-Type': 'text/plain'}
	send_data = "rsync,data_type={},data_source=sent value={}".format(type,sent_bytes)
	recv_data = "rsync,data_type={},data_source=recv value={}".format(type,recv_bytes)
	rate_data = "rsync,data_type={},data_source=rate value={}".format(type,rate)
	size_data = "rsync,data_type={},data_source=total_size value={}".format(type,total_size)
	speedup_data = "rsync,data_type={},data_source=speedup value={}".format(type,speedup)
	time_data = "rsync,data_type={},data_source=total_time value={}".format(type,minutes_elapsed)
	file_count_data = "rsync,data_type={},data_source=file_count value={}".format(type,file_count)
	dir_count_data = "rsync,data_type={},data_source=dir_count value={}".format(type,dir_count)

	# Send data to DB
	dlresponse = requests.post(base_url, headers=headers, data=send_data)
	print("Send Data: {}".format(dlresponse.status_code))

	dlresponse = requests.post(base_url, headers=headers, data=recv_data)
	print("Recv Data: {}".format(dlresponse.status_code))

	dlresponse = requests.post(base_url, headers=headers, data=rate_data)
	print("Rate Data: {}".format(dlresponse.status_code))

	dlresponse = requests.post(base_url, headers=headers, data=size_data)
	print("Size Data: {}".format(dlresponse.status_code))

	dlresponse = requests.post(base_url, headers=headers, data=speedup_data)
	print("Speedup Data: {}".format(dlresponse.status_code))

	dlresponse = requests.post(base_url, headers=headers, data=time_data)
	print("Time Data: {}".format(dlresponse.status_code))

	dlresponse = requests.post(base_url, headers=headers, data=file_count_data)
	print("File Count Data: {}".format(dlresponse.status_code))

	dlresponse = requests.post(base_url, headers=headers, data=dir_count_data)
	print("Dir Count Data: {}".format(dlresponse.status_code))

	# When logging is confident, delete archiving this. Just delete the file.
	# Move file to archive folder
	os.rename(log_file_path + log_file_name, log_file_archive + "{}.{}".format(log_file_name, datetime.datetime.now()))


process_rsync_log(storage_log_file_name)
process_rsync_log(media_log_file_name)
