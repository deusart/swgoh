from swgoh.sql.engine import execute

def update_member_character(
        allycode
        , character_id, is_legend, character_level, character_power, character_gear
        , character_stars, character_relic, character_zetas, character_omegas
        , gears_01, gears_02, gears_03, gears_04, gears_05, gears_06
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
    query += f"'{gears_01}', "
    query += f"'{gears_02}', "
    query += f"'{gears_03}', "
    query += f"'{gears_04}', "
    query += f"'{gears_05}', "
    query += f"'{gears_06}', "   
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
		, member_power_characters, member_power_ships
        , member_ligue, updated
        ):    
    query = "exec stage.insert_member "
    query += f"'{member_name}', "
    query += f"'{member_allycode}', "
    query += f"'{member_power}', "
    query += f"'{member_power_characters}', "
    query += f"'{member_power_ships}', "
    query += f"'{member_ligue}', "
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

def update_member_gac(
            member_allycode, season_id, event_id
			, gac_ligue, gac_division, gac_banners
			, gac_rank, gac_end_time
        ):    
    query = "exec stage.insert_member_gac "
    query += f"'{member_allycode}', "
    query += f"'{season_id}', "
    query += f"'{event_id}', "
    query += f"'{gac_ligue}', "
    query += f"'{gac_division}', "
    query += f"'{gac_banners}', "
    query += f"'{gac_rank}', "
    query += f"'{gac_end_time}' "
    execute(query)