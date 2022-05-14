from swgoh.engine.dictionaries import legends
from swgoh import sql

def opponent_truncate():
    sql.execute('TRUNCATE TABLE stage.opponents_characters;')
    sql.execute('TRUNCATE TABLE stage.opponents_ships;')

def opponent_name(name):
    sql.execute(f"UPDATE stage.customs SET custom_value_char = '{name}' WHERE custom_id = 'opponets_name';")


def opponent_units(allycode, updated, roster):
    for unit in roster:
        if unit['relic'] == None:
            __opponent_ship(allycode, updated, unit)
        else:
            __opponent_character(allycode, updated, unit)

def __opponent_character(allycode, updated, character):
    character_id = character['defId']
    character_stars = character['rarity']
    character_level = character['level']
    character_power = character['gp']
    character_gear = character['gear']
    if character['defId'] in legends:
        is_legend = True
    else:
        is_legend = False

    if  character['relic']['currentTier'] > 2:
        character_relic = character['relic']['currentTier'] - 2
    else:
        character_relic = 0

    character_zetas = 0
    character_omegas = 0

    for skill in character['skills']:
        if skill['tier'] == skill['tiers']:
            if skill['isZeta'] == True:
                character_zetas += 1
            else:
                character_omegas += 1

    character_power = character['gp'] + _relic_fix(character_relic)

    sql.opponents.update_opponent_character(
        allycode
        , character_id, is_legend, character_level, character_power, character_gear
        , character_stars, character_relic, character_zetas, character_omegas
        , updated
    )

def __opponent_ship(allycode, updated, ship): 
    ship_id = ship['defId']
    ship_stars = ship['rarity']
    ship_level = ship['level']
    ship_power = ship['gp']
    if ship['defId'] in legends:
        is_legend = True
    else:
        is_legend = False
    sql.opponents.update_opponent_ship(allycode, ship_id, is_legend, ship_level, ship_power, ship_stars, updated)


def _relic_fix(character_relic):    
    if character_relic == 1:
        return 759
    if character_relic == 2:
        return 1561
    if character_relic == 3:
        return 2505
    if character_relic == 4:
        return 3492
    if character_relic == 5:
        return 4554
    if character_relic == 6:
        return 6072 
    if character_relic == 7:
        return 7969
    if character_relic == 8:
        return 10246
    if character_relic == 9:
        return 0   
    else:
        return 0

