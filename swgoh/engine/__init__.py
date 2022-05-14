import json
from swgoh.engine.swgohhelp import SWGOH

swgoh = SWGOH()

def read_collection(source, collection):
    with open(f'{source}\{collection}.json') as json_data:
        data = json.load(json_data)
    return data

