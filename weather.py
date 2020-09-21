import logging
import requests 

logging.basicConfig(filename='weather_log.log',level=logging.DEBUG)

try: 
    URL = "https://api.openweathermap.org/data/2.5/weather?q=Carol Stream&appid=30b33ab3a8bca3900cf2e33c34770695&units=imperial"

    r = requests.get(url = URL) 

    data = r.json() 

    temperature = data['main']['temp']
    humidity = data['main']['humidity'] 

    base_url = "http://10.0.0.3:8086/write?db=extmonitors"
    headers = {'Content-Type': 'text/plain'}
    weather_temp_data = "weather,data_type=temperature value={}".format(temperature)
    weather_humidity_data = "weather,data_type=humidity value={}".format(humidity)

    dlresponse = requests.post(base_url, headers=headers, data=weather_temp_data)
    if dlresponse.status_code >= 300:
        logging.error('Failed to post weather temperature data to server: {}'.format(dlresponse.status_code))
    print('Failed to post weather temperature data to server: {}'.format(dlresponse.status_code))

    dlresponse = requests.post(base_url, headers=headers, data=weather_humidity_data)
    if dlresponse.status_code >= 300:
        logging.error('Failed to post weather humidity data to server: {}'.format(dlresponse.status_code))
    print('Failed to post weather humidity data to server: {}'.format(dlresponse.status_code))

except Exception as e:
    logging.error('Failed to record weather temperature: {}'.format(e))
    print('Failed to record weather temperature: {}'.format(e))

