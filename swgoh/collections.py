from swgoh import engine
from config.config import SOURCE
from swgoh.load import collections
import requests

def upload_collections(collection='all'):
    response = requests.get('http://api.swgoh.gg/characters', headers=None)
    characters = response.json()
    response = requests.get('http://api.swgoh.gg/ships', headers=None)
    ships = response.json()
    response = requests.get('http://api.swgoh.gg/gear', headers=None)
    gear = response.json()
    response = requests.get('http://api.swgoh.gg/abilities', headers=None)
    abilities = response.json()

    collections.characters(characters)
    collections.ships(ships)
    collections.gear(gear)
    collections.skills(abilities)