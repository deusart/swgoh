USE swgoh
GO

CREATE OR ALTER VIEW core.members_mods
AS
	SELECT 
		member_allycode
		, character_id
		, mod_id
		, mod_level
		, mod_pips
		, mod_set
		, mod_slot
		, mod_primary_stat AS mod_primary_num
		, fn.mod_stat(mod_primary_stat) AS mod_primary_stat
		, mod_primary_value
		, IIF(mod_slot = 2, 1, 0) AS is_arrow
		, (
			IIF(mod_second_01_stat = 5, mod_second_01_value/10000, 0)
			+ IIF(mod_second_02_stat = 5, mod_second_02_value/10000, 0)
			+ IIF(mod_second_03_stat = 5, mod_second_03_value/10000, 0)
			+ IIF(mod_second_04_stat = 5, mod_second_04_value/10000, 0)
		) AS mod_secondary_speed
	FROM stage.members_mods
GO