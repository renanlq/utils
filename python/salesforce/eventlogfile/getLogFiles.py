import os
from dotenv import load_dotenv

load_dotenv()
sf_domain = os.environ['SF_DOMAIN']
sf_consumerKey = os.environ['SF_CONSUMER_KEY']
sf_consumerSecret = os.environ['SF_CONSUMER_SECRET']

from simple_salesforce import Salesforce
sf = Salesforce(
    consumer_key=sf_consumerKey, 
    consumer_secret=sf_consumerSecret, 
    domain=sf_domain
    )

data = sf.query_all_iter("SELECT Id, CreatedDate, EventType, LogDate, LogFileLength, LogFile FROM EventLogFile WHERE LogDate = 2024-03-11T00:00:00.000+0000 AND Interval = 'Daily' ORDER BY EventType")
for row in data:
    print(row['LogFile'])