from swgoh import engine
from config.config import SOURCE
from swgoh.load import collections


def upload_collections(collection='all'):
    if collection == 'all':
        characters = engine.read_collection(SOURCE, 'characters')
        ships = engine.read_collection(SOURCE, 'ships')
        gear = engine.read_collection(SOURCE, 'gear')
        abilities = engine.read_collection(SOURCE, 'abilities')
        collections.characters(characters)
        collections.ships(ships)
        collections.gear(gear)
        collections.skills(abilities)
    else:
        if collection == 'characters':
            characters = engine.read_collection(SOURCE, 'characters')
            collections.characters(characters)
        elif collection == 'ships':
            characters = engine.read_collection(SOURCE, 'ships')
            collections.ships(ships)
        elif collection == 'gear':
            characters = engine.read_collection(SOURCE, 'gear')
            collections.gear(gear)
        else:
            abilities = engine.read_collection(SOURCE, 'abilities')
            collections.skills(abilities)