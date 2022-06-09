import json, os
from swgoh.engine.swgohhelp import SWGOH

swgoh = SWGOH()

def read_collection(source, collection):
    with open(f'{source}\{collection}.json') as json_data:
        data = json.load(json_data)
    return data

def save_log(path, message):
    try:
        os.mkdir(f'{path}')
    except OSError as error:
        pass 

    log = open(f'{path}\\log.txt', 'a')
    log.write(message)
    log.close()