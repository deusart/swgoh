from swgoh.engine.dictionaries import legends, ship_legends
from swgoh import sql

def get_players_list():
    query = """
        SELECT member_allycode
        FROM swgohdv.dm.members;
    """
    data = sql.select(query)
    allycodes = []

    for item in data:
        allycodes.append(item[0])

    return allycodes

def load_player(data):
    data = data[0]
    
    player_name = data['name'].replace('"','').replace("'","")
    player_allycode = data['allyCode']


    player_power = 0
    player_power_characters = 0
    player_power_ships = 0
    player_ligue = 0
    player_arena_rank = data['arena']['char']['rank']
    player_fleet_rank = data['arena']['ship']['rank']	
    
    player_characters_count = 0
    player_ships_count = 0
    player_legends_count = 0
    player_ship_legends_count = 0
    player_relics_count = 0
    player_relic_levels_count = 0

    stats = data['stats']
    for stat in stats:
        if stat['nameKey'] == 'STAT_GALACTIC_POWER_ACQUIRED_NAME': player_power = stat['value']
        if stat['nameKey'] == 'STAT_CHARACTER_GALACTIC_POWER_ACQUIRED_NAME': player_power_characters = stat['value']
        if stat['nameKey'] == 'STAT_SHIP_GALACTIC_POWER_ACQUIRED_NAME': player_power_ships = stat['value']

        if stat['nameKey'] == 'STAT_GALACTIC_POWER_ACQUIRED_NAME': player_power = stat['value']
        if stat['nameKey'] == 'STAT_GALACTIC_POWER_ACQUIRED_NAME': player_power = stat['value']


    if len(data['grandArena']) > 0:
        index = len(data['grandArena']) - 1
        player_ligue = data['grandArena'][index]['league']        
    else:
        player_ligue = ''

    player_guild = data['guildName']
    updated = data['updated']

    roster = data['roster']

    for unit in roster:
        if unit['relic'] == None:
            player_ships_count += 1
            if unit['defId'] in ship_legends:
                player_ship_legends_count += 1
        else:
            player_characters_count += 1
            if unit['defId'] in legends:
                player_legends_count += 1

            if unit['relic']['currentTier'] > 2:
                player_relics_count += 1
                player_relic_levels_count += unit['relic']['currentTier'] - 2

    sql.misc.update_player(player_name, player_allycode
    , player_power, player_power_characters
    , player_power_ships, player_ligue
    , player_arena_rank, player_fleet_rank	
    , player_characters_count, player_ships_count
    , player_legends_count, player_ship_legends_count
    , player_relics_count, player_relic_levels_count
    , player_guild
    , updated)
