USE swgoh
GO

CREATE OR ALTER PROCEDURE archive.daily_save
AS
BEGIN
	SELECT 'MODS'
	PRINT 'MODS'	 
	MERGE archive.daily_members_mods AS trg
    USING (
		SELECT CAST(GETDATE() AS DATE) AS log_date
			, member_allycode
			, mods_6_pips
			, mods_5_pips
			, mods_low_pips
			, mods_speed_count
			, mods_speed_15_plus
			, mods_speed_20_plus
			, mods_speed_25_plus
			, mods_speed_arrows
			, mods_not_speed_arrows
			, mods_secondary_speed_arrows
			, mods_total_count
			, mods_arrows
			, round(cast(mods_speed_arrows as float)/mods_arrows,2) -- mods_arrows_score
			+ round(cast(mods_6_pips as float)/mods_total_count,2) * 3 -- mods_pips_6_score
			+ round(cast(mods_5_pips as float)/mods_total_count,2) -- mods_pips_5_score
			+ round(cast(mods_speed_count as float)/(mods_total_count-mods_speed_arrows),2) -- mods_speed_score
			+ round(cast(mods_speed_15_plus as float)/(mods_total_count-mods_speed_arrows),2) * 5 -- mods_speed_15_score
			+ round(cast(mods_speed_20_plus as float)/(mods_total_count-mods_speed_arrows),2) * 10 -- mods_speed_20_score
			+ round(cast(mods_speed_25_plus as float)/(mods_total_count-mods_speed_arrows),2) * 15 -- mods_speed_25_score
		AS mods_quality
		FROM core.members_mods_total
	) AS src ON src.log_date = trg.log_date AND src.member_allycode = trg.member_allycode
    WHEN MATCHED THEN
		UPDATE 
			SET 
			trg.log_date = src.log_date
			, trg.member_allycode = src.member_allycode
			, trg.mods_6_pips = src.mods_6_pips
			, trg.mods_5_pips = src.mods_5_pips
			, trg.mods_low_pips = src.mods_low_pips
			, trg.mods_speed_count = src.mods_speed_count
			, trg.mods_speed_15_plus = src.mods_speed_15_plus
			, trg.mods_speed_20_plus = src.mods_speed_20_plus
			, trg.mods_speed_25_plus = src.mods_speed_25_plus
			, trg.mods_speed_arrows = src.mods_speed_arrows
			, trg.mods_not_speed_arrows = src.mods_not_speed_arrows
			, trg.mods_secondary_speed_arrows = src.mods_secondary_speed_arrows
			, trg.mods_total_count = src.mods_total_count
			, trg.mods_arrows = src.mods_arrows
			, trg.mods_quality = src.mods_quality
	WHEN NOT MATCHED THEN
		INSERT (
			log_date, member_allycode, mods_6_pips, mods_5_pips, mods_low_pips
			, mods_speed_count, mods_speed_15_plus, mods_speed_20_plus, mods_speed_25_plus
			, mods_speed_arrows, mods_not_speed_arrows, mods_secondary_speed_arrows
			, mods_total_count, mods_arrows, mods_quality
		) 
		VALUES (
			src.log_date, src.member_allycode, src.mods_6_pips, src.mods_5_pips, src.mods_low_pips
			, src.mods_speed_count, src.mods_speed_15_plus, src.mods_speed_20_plus, src.mods_speed_25_plus
			, src.mods_speed_arrows, src.mods_not_speed_arrows, src.mods_secondary_speed_arrows
			, src.mods_total_count, src.mods_arrows, src.mods_quality
		);

	PRINT ('MEMBERS')
	MERGE archive.daily_members AS trg
    USING (
		SELECT CAST(GETDATE() AS DATE) AS log_date
			, m.member_allycode
			, member_name
			, member_power
			, member_power_characters
			, member_power_ships
			, legends_count AS member_legends
			, relics_count AS member_relics
			, total_relic_levels AS member_relic_levels
			, total_zetas_applied AS member_zetas
			, total_omicrons_applied AS member_omicrons
			, characters_count AS member_characters
			, ships_count AS member_ships
			, g12_count AS member_characters_g12
			, rnk.member_fleet_rank
			, rnk.member_arena_rank
			, member_ligue
		FROM core.members m
		LEFT JOIN (
			SELECT 
				member_allycode
				, CAST(DATEADD(HOUR, 3, updated_at) AS DATE) AS log_date
				, MIN(member_squad_rank) as member_arena_rank
				, MIN(member_fleet_rank) as member_fleet_rank      
			FROM history.members_union
			WHERE member_squad_rank IS NOT NULL OR member_fleet_rank IS NOT NULL
			GROUP BY member_allycode, CAST(DATEADD(HOUR, 3, updated_at) AS DATE)
		) rnk ON m.member_allycode = rnk.member_allycode AND CAST(GETDATE() AS DATE) = rnk.log_date
	) AS src ON src.log_date = trg.log_date AND src.member_allycode = trg.member_allycode
    WHEN MATCHED THEN
		UPDATE 
			SET trg.member_name = src.member_name
			, trg.member_power = src.member_power
			, trg.member_power_characters = src.member_power_characters
			, trg.member_power_ships = src.member_power_ships
			, trg.member_legends = src.member_legends
			, trg.member_relics = src.member_relics
			, trg.member_relic_levels = src.member_relic_levels
			, trg.member_zetas = src.member_zetas
			, trg.member_omicrons = src.member_omicrons
			, trg.member_characters = src.member_characters
			, trg.member_ships = src.member_ships
			, trg.member_characters_g12 = src.member_characters_g12
			, trg.member_fleet_rank = src.member_fleet_rank
			, trg.member_arena_rank = src.member_arena_rank
			, trg.member_ligue = src.member_ligue
			, trg.updated_at = GETUTCDATE()
	WHEN NOT MATCHED THEN
		INSERT (
			log_date, member_allycode, member_name, member_power
			, member_power_characters, member_power_ships, member_legends
			, member_relics, member_relic_levels, member_zetas, member_omicrons
			, member_characters, member_ships, member_characters_g12, member_fleet_rank
			, member_arena_rank, member_ligue
		) 
		VALUES (
			src.log_date, src.member_allycode, src.member_name, src.member_power
			, src.member_power_characters, src.member_power_ships, src.member_legends
			, src.member_relics, src.member_relic_levels, src.member_zetas, src.member_omicrons
			, src.member_characters, src.member_ships, src.member_characters_g12, src.member_fleet_rank
			, src.member_arena_rank, src.member_ligue
		);
END
GO