# sf_helper.py
import requests

class SalesforceHelper:

    def __init__(self):
        raise NotImplementedError()

    def __init__(self, domain, sf_consumer_key, sf_consumer_secret, api_version):
        self.__domain = domain
        self.__sf_consumer_key = sf_consumer_key
        self.__sf_consumer_secret = sf_consumer_secret
        self.__api_version = api_version
        self.__auth_salesforce()

    def __auth_salesforce(self):
        try:
            self.__sf_auth_url = self.__domain + '/services/oauth2/token'
            http_response = requests.post(
                self.__sf_auth_url, data = {
                    'grant_type': 'client_credentials',
                    'client_id': self.__sf_consumer_key,
                    'client_secret': self.__sf_consumer_secret
                    })

            if "access_token" not in http_response.json() and not http_response.json()["access_token"]:
                print("token error")
                raise ValueError()

            json_response = http_response.json()
            sf_access_token = json_response['access_token']
            self.__sf_instance_url = json_response['instance_url']

            self.__sf_auth_headers = {
                'Authorization':'Bearer ' + sf_access_token, 
                'Content-type': 'application/json',
                'Accept-Encoding': 'gzip'
                }
        except BaseException as error:
            print('auth error')
            raise error
        
    def query(self, query):
        try:
            query_url =  self.__sf_instance_url + '/services/data/v'+self.__api_version+'/query/'
            parameters = {'q': query }     
            http_response = requests.request('get', query_url, headers = self.__sf_auth_headers, params = parameters, timeout = 30) 
            return http_response.json()['records']
        except BaseException as error:
            print('query error')
            raise error
    
    def get_file(self, file):
        try:
            file_url = self.__sf_instance_url + file 
            return requests.request('get', file_url, headers = self.__sf_auth_headers, timeout = 30)
        except BaseException as error:
            print('get file error')
            raise error