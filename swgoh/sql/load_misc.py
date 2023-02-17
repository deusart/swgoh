from swgoh.sql.engine import execute

def update_player(        
			player_name, player_allycode
			, player_power, player_power_characters
			, player_power_ships, player_ligue
			, player_arena_rank, player_fleet_rank	
			, player_characters_count, player_ships_count
			, player_legends_count, player_ship_legends_count
			, player_relics_count, player_relic_levels_count, player_guild
			, updated
        ):    
    query = "exec stage.insert_player "    
    query += f"'{player_allycode}', "
    query += f"'{player_name}', "
    query += f"'{player_power}', "
    query += f"'{player_power_characters}', "
    query += f"'{player_power_ships}', "
    query += f"'{player_ligue}', "
    query += f"'{player_arena_rank}', "
    query += f"'{player_fleet_rank}', "
    query += f"'{player_characters_count}', "
    query += f"'{player_ships_count}', "
    query += f"'{player_legends_count}', "
    query += f"'{player_ship_legends_count}', "
    query += f"'{player_relics_count}', "
    query += f"'{player_relic_levels_count}', "
    query += f"'{player_guild}', "  
    query += f"'{updated}' "
    execute(query)