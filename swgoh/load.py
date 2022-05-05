from swgoh.dictionaries import legends
from swgoh import mssql

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
    mssql.insert_member_character_skill(
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

    mssql.update_member_character(
        allycode
        , character_id, is_legend, character_level, character_power, character_stars
        , character_relic, character_zetas, character_omegas
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

    mssql.update_member_ship(allycode, ship_id, is_legend, ship_level, ship_power, ship_stars, updated)

def member(member):
    mssql.update_member(
        member['name'], member['allyCode'], member['gp']
        , member['gpChar'], member['gpShip'], member['updated']
        )

def ships(ships):
    for ship in ships:  
        mssql.update_ship(
            ship["base_id"], ship["name"].replace('"','').replace("'",""), ship["url"]
            , ship["image"], ship["power"], ship["description"].replace('"','').replace("'","")
            , ship["alignment"], ship['capital_ship'], ship['activate_shard_count']
            )
        print(f'Ship: {ship["name"]} updated.')

def characters(characters):
    for character in characters:
        mssql.update_character(
            character["base_id"], character["name"].replace('"','').replace("'",""), character["url"]
            , character["image"], character["power"], character["description"].replace('"','').replace("'","")
            , character["alignment"], character['ship'], character['activate_shard_count']
            )

        for tier in character["gear_levels"]:
            if tier['tier'] < 13:
                mssql.update_character_gear(
                    character["base_id"]
                    , tier['tier']
                    , tier['gear'][0]
                    , tier['gear'][1]
                    , tier['gear'][2]
                    , tier['gear'][3]
                    , tier['gear'][4]
                    , tier['gear'][5]
                )

        print(f'Character: {character["name"]} updated.')

def gear(gears):
    for gear in gears:
        mssql.update_gear(
            gear["base_id"], gear["name"].replace('"','').replace("'",""), gear["tier"]
            , gear["required_level"], gear["url"], gear["image"]
            , gear["cost"], gear['mark']
            )
        for gear_part in gear['ingredients']:
            mssql.update_gear_recipe(gear["base_id"], gear_part['gear'], gear_part['amount'])
        
        print(f'Gear: {gear["name"]} updated.')