import os
import requests

from dotenv import load_dotenv
from datetime import datetime
load_dotenv()

print(datetime.now())

sfDomain = os.environ['SF_DOMAIN']
sfConsumerKey = os.environ['SF_CONSUMER_KEY']
sfConsumerSecret = os.environ['SF_CONSUMER_SECRET']

sfAuthUrl = sfDomain + '/services/oauth2/token'
httpResponse = requests.post(sfAuthUrl, data = {
                    'grant_type': 'client_credentials',
                    'client_id': sfConsumerKey,
                    'client_secret': sfConsumerSecret
                    })

if "access_token" not in httpResponse.json() and not httpResponse.json()["access_token"]:
    print("login error")
    exit()
    
jsonResponse = httpResponse.json()
sfAccessToken = jsonResponse['access_token']
sfInstanceUrl = jsonResponse['instance_url']

sfAuthHeaders = {
    'Authorization':'Bearer ' + sfAccessToken, 
    'Content-type': 'application/json',
    'Accept-Encoding': 'gzip'
    }

sfAuthUrl = sfInstanceUrl + '/services/data/v60.0/'

queryUrl =  sfAuthUrl + 'query/'
parameters = {'q': "SELECT Id, LogFile, LogFileContentType FROM EventLogFile WHERE LogDate = 2024-03-11T00:00:00.000+0000 AND Interval = 'Daily'" }     
httpResponse = requests.request('get', queryUrl, headers = sfAuthHeaders, params = parameters, timeout = 30) 
eventData = httpResponse.json()['records']

for row in eventData:
    print(row['LogFile'])

    fileUrl = sfInstanceUrl + row['LogFile']
    print(fileUrl)

    httpResponse = requests.request('get', fileUrl, headers = sfAuthHeaders, timeout = 30) 
    print(httpResponse)

    with open('Files/'+row['Id']+'.csv', 'wb') as fileManager:
        fileManager.write(httpResponse.content)
