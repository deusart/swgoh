USE swgoh
GO

CREATE OR ALTER VIEW player.profile
AS
	SELECT 
		row_id
		, member_allycode, member_name
		, member_power, member_power_characters, member_power_ships, member_ligue
		, total_omicrons_applied, total_zetas_applied, total_omegas_applied
		, total_omicron_tw, total_omicron_ga, total_omicron_ga3x3, total_omicron_tb
		, ships_count, characters_count, legends_count, relics_count
		, r9_count, r8_count, r7_count, r0_6_count, g12_count
		, updated_at
	FROM core.members
	WHERE member_allycode = fn.player()
GO