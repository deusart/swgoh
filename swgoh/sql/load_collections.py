from swgoh.sql.engine import execute

def empty_output(value):
    pass

output = empty_output


def update_character(character_id, character_name, character_url
            , character_image, character_power, character_description
            , character_alignment, character_ship, character_shards, character_tags):
    query = "exec stage.insert_character "
    query += f"'{character_id}', "
    query += f"'{character_name}', "
    query += f"'{character_url}', "
    query += f"'{character_image}', "
    query += f"'{character_power}', "
    query += f"'{character_description}', "
    query += f"'{character_alignment}', "
    query += f"'{character_ship}', "
    query += f"'{character_shards}', "
    query += f"'{character_tags}'"
    output(query)
    execute(query)

def update_ship(ship_id, ship_name, ship_url
            , ship_image, ship_power, ship_description
            , ship_alignment, ship_capital_ship, ship_shards
            , ship_tags):
    query = "exec stage.insert_ship "
    query += f"'{ship_id}', "
    query += f"'{ship_name}', "
    query += f"'{ship_url}', "
    query += f"'{ship_image}', "
    query += f"'{ship_power}', "
    query += f"'{ship_description}', "
    query += f"'{ship_alignment}', "
    query += f"'{ship_capital_ship}', "
    query += f"'{ship_shards}',"
    query += f"'{ship_tags}'"
    output(query)
    execute(query)

def update_character_gear(character_id, character_tier
        , gear_slot_01, gear_slot_02, gear_slot_03
        , gear_slot_04, gear_slot_05, gear_slot_06):
    query = "exec stage.insert_character_gear "
    query += f"'{character_id}', "
    query += f"'{character_tier}', "
    query += f"'{gear_slot_01}', "
    query += f"'{gear_slot_02}', "
    query += f"'{gear_slot_03}', "
    query += f"'{gear_slot_04}', "
    query += f"'{gear_slot_05}', "
    query += f"'{gear_slot_06}' "
    output(query)
    execute(query)

def update_gear(gear_id, gear_name
        , gear_tier, gear_required_level, gear_url
        , gear_image, gear_cost, gear_mark):
    query = "exec stage.insert_gear "
    query += f"'{gear_id}', "
    query += f"'{gear_name}', "
    query += f"'{gear_tier}', "
    query += f"'{gear_required_level}', "
    query += f"'{gear_url}', "
    query += f"'{gear_image}', "
    query += f"'{gear_cost}', "
    query += f"'{gear_mark}' "
    output(query)
    execute(query)

def update_gear_recipe(gear_id, gear_part_id, amount):    
    query = "exec stage.insert_gear_recipe "
    query += f"'{gear_id}', "
    query += f"'{gear_part_id}', "
    query += f"'{amount}' "
    output(query)
    execute(query)

def update_skill(
        ability_id, character_id, ability_name
        , tier_max, is_zeta, is_omega, is_omicron
        , omicron_mode    
    ):    
    query = "exec stage.insert_skill "
    query += f"'{ability_id}', "
    query += f"'{character_id}', "
    query += f"'{ability_name}', "
    query += f"'{tier_max}', "
    query += f"'{is_zeta}', "
    query += f"'{is_omega}', "
    query += f"'{is_omicron}', "
    query += f"'{omicron_mode}' "
    output(query)
    execute(query)
    
 