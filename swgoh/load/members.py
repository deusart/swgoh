from swgoh.engine.dictionaries import legends
from swgoh import sql

def prepare_current(roster):

    members_current = roster[0]['allyCode']
    for member in roster[1:]:
        allycode = str(member['allyCode'])
        members_current = f'{members_current},{allycode}'
    query = f"EXEC stage.insert_members_current '{members_current}'"
    sql.execute(query)

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

    equipped = list()
    for gear in character['equipped']:
        equipped.append(gear['slot'])

    gears = list()
    for step in range(6):
        if step in equipped:
            gears.append(1)
        else:
            gears.append(0)

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

    __member_mods(allycode, character_id, character['mods'])

    character_power = character['gp'] + _relic_fix(character_relic)

    sql.members.update_member_character(
        allycode
        , character_id, is_legend, character_level, character_power, character_gear
        , character_stars, character_relic, character_zetas, character_omegas
        , gears[0], gears[1], gears[2], gears[3], gears[4], gears[5]
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

def __member_gac(allycode, grand_arena):
    for season in grand_arena:
        sql.members.update_member_gac(
            allycode, season['seasonId'], season['eventInstanceId']
			, season['league'], season['division'], season['seasonPoints']
			, season['rank'], season['endTime']
            )

def __member_mods(allycode, character_id, mods):

    for mod in mods:

        secondary = {}
        if len(mod['secondaryStat']) > 0:
            secondary['slot_01_stat'] = mod['secondaryStat'][0]['unitStat']
            secondary['slot_01_value'] = mod['secondaryStat'][0]['value']
            secondary['slot_01_roll'] =  mod['secondaryStat'][0]['roll']
        else:
            secondary['slot_01_stat'] = 0
            secondary['slot_01_value'] = 0
            secondary['slot_01_roll'] = 0
        if len(mod['secondaryStat']) > 1:
            secondary['slot_02_stat'] = mod['secondaryStat'][1]['unitStat']
            secondary['slot_02_value'] = mod['secondaryStat'][1]['value']
            secondary['slot_02_roll'] =  mod['secondaryStat'][1]['roll']
        else:
            secondary['slot_02_stat'] = 0
            secondary['slot_02_value'] = 0
            secondary['slot_02_roll'] = 0
        if len(mod['secondaryStat']) > 2:
            secondary['slot_03_stat'] = mod['secondaryStat'][2]['unitStat']
            secondary['slot_03_value'] = mod['secondaryStat'][2]['value']
            secondary['slot_03_roll'] =  mod['secondaryStat'][2]['roll']
        else:
            secondary['slot_03_stat'] = 0
            secondary['slot_03_value'] = 0
            secondary['slot_03_roll'] = 0
        if len(mod['secondaryStat']) > 3:
            secondary['slot_04_stat'] = mod['secondaryStat'][3]['unitStat']
            secondary['slot_04_value'] = mod['secondaryStat'][3]['value']
            secondary['slot_04_roll'] =  mod['secondaryStat'][3]['roll']
        else:
            secondary['slot_04_stat'] = 0
            secondary['slot_04_value'] = 0
            secondary['slot_04_roll'] = 0

        sql.members.update_member_mod(
            allycode, character_id, mod['id'], mod['level'], mod['pips']
			, mod['set'], mod['slot'],  mod['primaryStat']['unitStat'], mod['primaryStat']['value']
			, secondary['slot_01_stat'], secondary['slot_01_value'], secondary['slot_01_roll']
			, secondary['slot_02_stat'], secondary['slot_02_value'], secondary['slot_02_roll']
			, secondary['slot_03_stat'], secondary['slot_03_value'], secondary['slot_03_roll']
			, secondary['slot_04_stat'], secondary['slot_04_value'], secondary['slot_04_roll']
            )

def member(member):

    if len(member['grandArena']) > 0:
        index = len(member['grandArena']) - 1
        ligue = member['grandArena'][index]['league']
        __member_gac(member['allyCode'], member['grandArena'])
    else:
        ligue = 0

    name = member['name'].replace('"','').replace("'","")

    sql.members.update_member(
        name, member['allyCode'], member['gp']
        , member['gpChar'], member['gpShip'], ligue
        , member['squad_rank'], member['fleet_rank']
        , member['updated']        
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

def member_swgohgg(member):
    allycode = member['data']['ally_code']
    skill_rating = member['data']['skill_rating']
    lastupdated = member['data']['last_updated']
    lastupdated = lastupdated.replace('T',' ')
    datacrons = [0] * 10
    for item in member['datacrons']:
        datacrons[item['tier']] += 1
        
    sql.members.update_member_swgohgg(
        allycode, skill_rating, 
        datacrons[0], datacrons[1], datacrons[2],
        datacrons[3], datacrons[4], datacrons[5],
        datacrons[6], datacrons[7], datacrons[8],
        datacrons[9], lastupdated
        )