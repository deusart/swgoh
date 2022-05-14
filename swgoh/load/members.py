from swgoh.engine.dictionaries import legends
from swgoh import sql

def prepare_current():
    sql.execute('UPDATE stage.members SET member_current = 0 WHERE updated_at < (getdate()-1)')

def member_units(allycode, updated, roster):
    for unit in roster:
        if unit['relic'] == None:
            __member_ship(allycode, updated, unit)
        else:
            __member_character(allycode, updated, unit)

def __member_character_skill(member_allycode, updated, character_id, skill):
    if skill['isZeta']:
        is_zeta = 1
    else:
        is_zeta = 0
    sql.members.update_member_character_skill(
		member_allycode
        , character_id
        , skill['id']
		, skill['tier']
        , skill['tiers']
        , is_zeta
		, updated
        )

def __member_character(allycode, updated, character):
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
        __member_character_skill(allycode, updated, character_id, skill) 
        if skill['tier'] == skill['tiers']:
            if skill['isZeta'] == True:
                character_zetas += 1
            else:
                character_omegas += 1

    character_power = character['gp'] + _relic_fix(character_relic)

    sql.members.update_member_character(
        allycode
        , character_id, is_legend, character_level, character_power, character_gear
        , character_stars, character_relic, character_zetas, character_omegas
        , updated
    )

def __member_ship(allycode, updated, ship): 
    ship_id = ship['defId']
    ship_stars = ship['rarity']
    ship_level = ship['level']
    ship_power = ship['gp']
    if ship['defId'] in legends:
        is_legend = True
    else:
        is_legend = False

    sql.members.update_member_ship(allycode, ship_id, is_legend, ship_level, ship_power, ship_stars, updated)

def member(member):
    sql.members.update_member(
        member['name'], member['allyCode'], member['gp']
        , member['gpChar'], member['gpShip'], member['updated']
        )

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

