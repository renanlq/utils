import os

from datetime import datetime
from dotenv import load_dotenv
from sf_helper import SalesforceHelper

load_dotenv()
sf_domain = os.environ['SF_DOMAIN']
sf_consumer_key = os.environ['SF_CONSUMER_KEY']
sf_consumer_secret = os.environ['SF_CONSUMER_SECRET']
sf_api_version = os.environ['SF_API_VERSION']

sfHelper = SalesforceHelper(sf_domain,sf_consumer_key,sf_consumer_secret,sf_api_version)
event_data = sfHelper.query(
    "SELECT Id, LogFile, LogFileContentType FROM EventLogFile WHERE LogDate = 2024-03-11T00:00:00.000+0000 AND Interval = 'Daily'"
    )

for row in event_data:
    log_file = sfHelper.get_file(row['LogFile'])
    with open('Files/'+row['Id']+'.csv', 'wb') as file_manager:
        file_manager.write(log_file.content)
