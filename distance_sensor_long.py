#!/usr/bin/python
import RPi.GPIO as GPIO
import time
import requests
import json
import logging

try:
        GPIO.setmode(GPIO.BOARD)

        PIN_TRIGGER = 7
        PIN_ECHO = 11

        GPIO.setup(PIN_TRIGGER, GPIO.OUT)
        GPIO.setup(PIN_ECHO, GPIO.IN)

        GPIO.output(PIN_TRIGGER, GPIO.LOW)

        print "Waiting for sensor to settle"

        time.sleep(2)

        while 1:
                print "Calculating distance"

                GPIO.output(PIN_TRIGGER, GPIO.HIGH)

                time.sleep(0.00001)

                GPIO.output(PIN_TRIGGER, GPIO.LOW)

                while GPIO.input(PIN_ECHO)==0:
                        pulse_start_time = time.time()
                while GPIO.input(PIN_ECHO)==1:
                        pulse_end_time = time.time()

                pulse_duration = pulse_end_time - pulse_start_time
                distance = round(pulse_duration * 17150, 2)
                print "Distance:",distance,"cm"

                base_url = "http://192.168.1.109:8086/write?db=extmonitors"
                headers = {'Content-Type': 'text/plain'}
                distance_data = "bailey,data_type=distance value={}".format(distance)

                dlresponse = requests.post(base_url, headers=headers, data=distance_data)
                if dlresponse.status_code >= 300:
                        logging.basicConfig(filename='distance_log.log',level=logging.DEBUG)
                        logging.error('Failed to post distance data for Baileys water bowl: {}'.format(dlresponse.status_code))
                        print('Failed to post distance data for Baileys water bowl: {}'.format(dlresponse.status_code))

finally:
      GPIO.cleanup()