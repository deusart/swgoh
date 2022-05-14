from swgoh import sql


def ships(ships):
    for ship in ships:  
        sql.collections.update_ship(
            ship["base_id"], ship["name"].replace('"','').replace("'",""), ship["url"]
            , ship["image"], ship["power"], ship["description"].replace('"','').replace("'","")
            , ship["alignment"], ship['capital_ship'], ship['activate_shard_count'], str(ship['categories']).replace('"','|').replace("'","|")
            )
        print(f'Ship: {ship["name"]} updated.')

def characters(characters):
    for character in characters:

        sql.collections.update_character(
            character["base_id"], character["name"].replace('"','').replace("'",""), character["url"]
            , character["image"], character["power"], character["description"].replace('"','').replace("'","")
            , character["alignment"], character['ship'], character['activate_shard_count'], str(character['categories']).replace('"','|').replace("'","|")
            )

        for tier in character["gear_levels"]:
            if tier['tier'] < 13:
                sql.collections.update_character_gear(
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
        sql.collections.update_gear(
            gear["base_id"], gear["name"].replace('"','').replace("'",""), gear["tier"]
            , gear["required_level"], gear["url"], gear["image"]
            , gear["cost"], gear['mark']
            )
        for gear_part in gear['ingredients']:
            sql.collections.update_gear_recipe(gear["base_id"], gear_part['gear'], gear_part['amount'])
        
        print(f'Gear: {gear["name"]} updated.')

def skills(abilities):
    for ability in abilities:
        if ability['omicron_mode'] == None:
            omicron_mode = 1
        else:
            omicron_mode = ability['omicron_mode'] 

        sql.collections.update_skill(
            ability['base_id']
            , ability['character_base_id']
            , ability['name'].replace('"','').replace("'","")
            , ability['tier_max']
            , __bool_int(ability['is_zeta'])
            , __bool_int(ability['is_omega'])
            , __bool_int(ability['is_omicron'])   
            , omicron_mode
        )
        print(f'Skill: {ability["name"]} updated.')

def __bool_int(value):
    if value:
        return 1
    else:
        return 0