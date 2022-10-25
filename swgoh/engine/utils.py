import json, os
import datetime

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
    date = str(datetime.datetime.now())[:16]
    message = f'[{date}] {message}\n'
    log.write(message)
    log.close()