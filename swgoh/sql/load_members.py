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
        , member_ligue, member_squad_rank, member_fleet_rank
        , updated
        ):    
    query = "exec stage.insert_member "
    query += f"'{member_name}', "
    query += f"'{member_allycode}', "
    query += f"'{member_power}', "
    query += f"'{member_power_characters}', "
    query += f"'{member_power_ships}', "
    query += f"'{member_ligue}', "
    query += f"'{member_squad_rank}', "
    query += f"'{member_fleet_rank}', "
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

def update_member_mod(
			member_allycode, character_id, mod_id, mod_level, mod_pips
			, mod_set, mod_slot, mod_primary_stat, mod_primary_value
			, mod_second_01_stat, mod_second_01_value, mod_second_01_roll
			, mod_second_02_stat, mod_second_02_value, mod_second_02_roll
			, mod_second_03_stat, mod_second_03_value, mod_second_03_roll
			, mod_second_04_stat, mod_second_04_value, mod_second_04_roll
        ):    
    query = "exec stage.insert_member_mod "
    query += f"'{member_allycode}', "
    query += f"'{character_id}', "
    query += f"'{mod_id}', "
    query += f"'{mod_level}', "
    query += f"'{mod_pips}', "
    query += f"'{mod_set}', "
    query += f"'{mod_slot}', "
    query += f"'{mod_primary_stat}', "
    query += f"'{mod_primary_value}', "
    query += f"'{mod_second_01_stat}', "
    query += f"'{mod_second_01_value}', "
    query += f"'{mod_second_01_roll}', "
    query += f"'{mod_second_02_stat}', "
    query += f"'{mod_second_02_value}', "
    query += f"'{mod_second_02_roll}', "
    query += f"'{mod_second_03_stat}', "
    query += f"'{mod_second_03_value}', "
    query += f"'{mod_second_03_roll}', "
    query += f"'{mod_second_04_stat}', "
    query += f"'{mod_second_04_value}', "
    query += f"'{mod_second_04_roll}' "
    execute(query)

def update_member_swgohgg(
            member_allycode, skillrating, datacrons_0, datacrons_1
            , datacrons_2, datacrons_3, datacrons_4, datacrons_5
            , datacrons_6, datacrons_7, datacrons_8, datacrons_9	
            , last_updated
        ):    
    query = "exec stage.insert_member_swgohgg "
    query += f"'{member_allycode}', "
    query += f"'{skillrating}', "
    query += f"'{datacrons_0}', "
    query += f"'{datacrons_1}', "
    query += f"'{datacrons_2}', "
    query += f"'{datacrons_3}', "
    query += f"'{datacrons_4}', "
    query += f"'{datacrons_5}', "
    query += f"'{datacrons_6}', "
    query += f"'{datacrons_7}', "
    query += f"'{datacrons_8}', "
    query += f"'{datacrons_9}', "
    query += f"'{last_updated}' "
    print(query)
    execute(query)

    
