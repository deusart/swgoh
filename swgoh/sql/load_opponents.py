from swgoh.sql.engine import execute

def update_opponent_character(
        allycode
        , character_id, is_legend, character_level, character_power, character_gear
        , character_stars, character_relic, character_zetas, character_omegas
        , updated
        ):    
    query = "exec stage.insert_opponent_character "
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

def update_opponent_ship(
        allycode, ship_id, is_legend, ship_level
        , ship_power, ship_stars, updated
    ): 
    query = "exec stage.insert_opponent_ship "
    query += f"'{allycode}', "
    query += f"'{ship_id}', "
    query += f"'{is_legend}', "
    query += f"'{ship_level}', "
    query += f"'{ship_power}', "
    query += f"'{ship_stars}', "    
    query += f"'{updated}' "
    execute(query)

def update_opponent(
		opponent_allycode, opponent_name
		, opponent_power, opponent_ligue, updated 
    ): 
    query = "exec stage.insert_opponent "
    query += f"'{opponent_allycode}', "
    query += f"'{opponent_name}', "
    query += f"'{opponent_power}', "
    query += f"'{opponent_ligue}', "  
    query += f"'{updated}' "
    execute(query)