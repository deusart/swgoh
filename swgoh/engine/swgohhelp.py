from swgoh.engine.dictionaries import urls
import requests
import config.config as config
from json import loads, dumps
from swgoh.engine.utils import save_log

class SWGOH(object):
    def __init__(self
            , username=None
            , password=None
            , allycode=None
        ):
        # settings
        template = "username=%s&password=%s&grant_type=password"
        template += "&client_id=123&client_secret=def"
        if allycode == None:
            self.allycode = config.ALLYCODE
        if username == password == None:        
            self.user = template % (config.LOGIN, config.PASSWORD)
        else:
            self.user = template % (username, password)        
        self.__get_token()

    def __get_token(self):
        head = {"Content-type": "application/x-www-form-urlencoded",
                'Content-Length': str(len(self.user))}
        response = requests.request('POST', urls['signin'], headers=head, data=self.user, timeout = 10)
        if response.status_code != 200:
            error = 'Cannot login with these credentials'
            return  {"status_code" : response.status_code,
                     "message": error}
        _token = loads(response.content.decode('utf-8'))['access_token']
        self.head = {'Method': 'POST','Content-Type': 'application/json','Authorization': "Bearer "+_token}
        save_log(config.LOG, 'Token received')

    def __get_data(self, url, data):
        try:
            response = requests.request('POST', url, headers=self.head, data = dumps(data))
            if response.status_code != 200:
                error = 'Cannot fetch data - error code'
                data = {"status_code" : response.status_code,
                         "message": error}
            data = loads(response.content.decode('utf-8'))
            # save_log(config.LOG, 'Data received')
        except Exception as err:
            data = {"message": 'Cannot fetch data'}
            save_log(config.LOG, 'Data receiving failed')
            save_log(config.LOG, err)
        return data    

    def __userdata(self, collection, allycode=None):
        if allycode == None:
            allycode = self.allycode
        data = {'allycode': allycode}
        return self.__get_data(urls[collection], data)

    def collection(self, collection):
        data = {'collection': collection}
        return self.__get_data(urls['data'], data)

    def player(self, allycode=None):
        return self.__userdata('player', allycode)

    def guild(self, allycode=None):        
        return self.__userdata('guild', allycode)
    
    def gear(self):
        return self.collection('equipmentList')

    def units(self):
        return self.collection('unitsList')

    def recipes(self):
        return self.collection('recipeList')