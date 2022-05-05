import pyodbc
import config

def execute(query):    
    connection = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER='+config.SERVER+';DATABASE='+config.DATABASE+';UID='+config.SQLUSERNAME+';PWD='+ config.SQLPASSWORD)
    cursor = connection.cursor()
    cursor.execute(query)
    connection.commit()
    connection.close()

def update_member_character(
        allycode
        , character_id, is_legend, character_level, character_power, character_stars
        , character_relic, character_zetas, character_omegas
        , updated
        ):    
    query = "exec stage.insert_member_character "
    query += f"'{allycode}', "
    query += f"'{character_id}', "
    query += f"'{is_legend}', "
    query += f"'{character_level}', "
    query += f"'{character_power}', "
    query += f"'{character_stars}', "
    query += f"'{character_relic}', "
    query += f"'{character_zetas}', "
    query += f"'{character_omegas}', "   
    query += f"'{updated}' "
    execute(query)

def update_member_ship(
        allycode, ship_id, is_legend, ship_level
        , ship_power, ship_stars, updated
    ): 
    query = "exec stage.insert_member_ship "
    query += f"'{allycode}', "
    query += f"'{ship_id}', "
    query += f"'{is_legend}', "
    query += f"'{ship_level}', "
    query += f"'{ship_power}', "
    query += f"'{ship_stars}', "    
    query += f"'{updated}' "
    execute(query)

def update_member(
		member_name, member_allycode, member_power
		, member_power_characters, member_power_ships, updated
        ):    
    query = "exec stage.insert_member "
    query += f"'{member_name}', "
    query += f"'{member_allycode}', "
    query += f"'{member_power}', "
    query += f"'{member_power_characters}', "
    query += f"'{member_power_ships}', "
    query += f"'{updated}' "
    execute(query)

def insert_member_character_skill(
            member_allycode, character_id, skill_id
			, tier, tier_max, is_zeta
			, updated
        ):    
    query = "exec stage.insert_member_character_skill "
    query += f"'{member_allycode}', "
    query += f"'{character_id}', "
    query += f"'{skill_id}', "
    query += f"'{tier}', "
    query += f"'{tier_max}', "
    query += f"'{is_zeta}', "
    query += f"'{updated}' "
    execute(query)

def update_character(character_id, character_name, character_url
            , character_image, character_power, character_description
            , character_alignment, character_ship, character_shards):
    query = "exec stage.insert_character "
    query += f"'{character_id}', "
    query += f"'{character_name}', "
    query += f"'{character_url}', "
    query += f"'{character_image}', "
    query += f"'{character_power}', "
    query += f"'{character_description}', "
    query += f"'{character_alignment}', "
    query += f"'{character_ship}', "
    query += f"'{character_shards}'"
    execute(query)

def update_ship(ship_id, ship_name, ship_url
            , ship_image, ship_power, ship_description
            , ship_alignment, ship_capital_ship, ship_shards):
    query = "exec stage.insert_ship "
    query += f"'{ship_id}', "
    query += f"'{ship_name}', "
    query += f"'{ship_url}', "
    query += f"'{ship_image}', "
    query += f"'{ship_power}', "
    query += f"'{ship_description}', "
    query += f"'{ship_alignment}', "
    query += f"'{ship_capital_ship}', "
    query += f"'{ship_shards}'"
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
    execute(query)

def update_gear_recipe(gear_id, gear_part_id, amount):    
    query = "exec stage.insert_gear_recipe "
    query += f"'{gear_id}', "
    query += f"'{gear_part_id}', "
    query += f"'{amount}' "
    execute(query)