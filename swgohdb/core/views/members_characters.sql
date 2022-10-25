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
		, ISNULL(mcs.omicrons_applied,0) AS omicrons_applied
		, ISNULL(mcs.zetas_applied,0) AS zetas_applied
		, ISNULL(mcs.omegas_applied,0) AS omegas_applied
		, ISNULL(mcs.full_update,0) AS full_update
		, ISNULL(mcs.omicron_tw,0) AS omicron_tw
		, ISNULL(mcs.omicron_ga,0) AS omicron_ga
		, ISNULL(mcs.omicron_tb,0) AS omicron_tb
		, ISNULL(mcs.omicron_ga3x3,0) AS omicron_ga3x3
	FROM stage.members_characters AS mc
	LEFT JOIN rules.members_characters_skills AS mcs
		ON mc.member_allycode = mcs.member_allycode
		AND mc.character_id = mcs.character_id
GO