import requests
import Adafruit_DHT
import time
import datetime
import psycopg2
import logging
import json

logging.basicConfig(filename='beer_log.log',level=logging.DEBUG)

sensor = Adafruit_DHT.DHT22
pin = 26

try:
    humidity, temperature = Adafruit_DHT.read_retry(sensor, pin)

    temperature = temperature * 1.8 + 32

    logging.info(datetime.datetime.now())
    logging.info('Temperature {}'.format(temperature))
    logging.info('Humidity {}'.format(humidity))
    print(datetime.datetime.now())
    print('Temperature {}'.format(temperature))
    print('Humidity {}'.format(humidity))

    base_url = "http://10.0.0.3:8086/write?db=extmonitors"
    headers = {'Content-Type': 'text/plain'}
    beer_temp_data = "beer,data_type=temperature value={}".format(temperature)
    beer_humidity_data = "beer,data_type=humidity value={}".format(humidity)

    dlresponse = requests.post(base_url, headers=headers, data=beer_temp_data)
    if dlresponse.status_code >= 300:
        logging.error('Failed to post beer temperature data to server: {}'.format(dlresponse.status_code))
	print('Failed to post beer temperature data to server: {}'.format(dlresponse.status_code))

    dlresponse = requests.post(base_url, headers=headers, data=beer_humidity_data)
    if dlresponse.status_code >= 300:
        logging.error('Failed to post beer humidity data to server: {}'.format(dlresponse.status_code))
	print('Failed to post beer humidity data to server: {}'.format(dlresponse.status_code))


except Exception as e:
    logging.error('Failed to record beer temperature: {}'.format(e))
    print('Failed to record beer temperature: {}'.format(e))
