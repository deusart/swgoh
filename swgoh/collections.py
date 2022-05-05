import json
from swgoh import load
from config import SOURCE

def read_collection(source, collection):
    with open(f'{source}\{collection}.json') as json_data:
        data = json.load(json_data)
    return data

def upload_collections():
    characters = read_collection(SOURCE, 'characters')
    ships = read_collection(SOURCE, 'ships')
    gear = read_collection(SOURCE, 'gear')

    load.characters(characters)
    load.ships(ships)
    load.gear(gear)