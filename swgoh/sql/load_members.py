from swgoh.sql.engine import execute

def update_member_character(
        allycode
        , character_id, is_legend, character_level, character_power, character_gear
        , character_stars, character_relic, character_zetas, character_omegas
        , updated
        ):    
    query = "exec stage.insert_member_character "
    query += f"'{allycode}', "
    query += f"'{character_id}', "
    query += f"'{is_legend}', "
    query += f"'{character_level}', "
    query += f"'{character_power}', "
    query += f"'{character_gear}', "
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

def update_member_character_skill(
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
