from swgoh import engine
from config import SOURCE
from swgoh.load import collections


def upload_collections():

    characters = engine.read_collection(SOURCE, 'characters')
    ships = engine.read_collection(SOURCE, 'ships')
    gear = engine.read_collection(SOURCE, 'gear')
    abilities = engine.read_collection(SOURCE, 'abilities')

    collections.characters(characters)
    collections.ships(ships)
    collections.gear(gear)
    collections.skills(abilities)