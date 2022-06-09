USE swgoh
GO

CREATE OR ALTER VIEW core.members_characters
AS
	SELECT 
		mc.member_allycode
		, mc.character_id
		, mc.character_gear
		, mc.character_level
		, mc.character_relic
		, mc.character_stars
		, mc.character_power
		, mcs.omicrons_applied
		, mcs.zetas_applied
		, mcs.omegas_applied
		, mcs.full_update
		, mcs.omicron_tw
		, mcs.omicron_ga
		, mcs.omicron_tb
		, mcs.omicron_ga3x3
	FROM stage.members_characters AS mc
	INNER JOIN rules.members_characters_skills AS mcs
		ON mc.member_allycode = mcs.member_allycode
		AND mc.character_id = mcs.character_id
GO