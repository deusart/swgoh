USE swgoh
GO

CREATE OR ALTER VIEW core.members
AS
	SELECT 
		m.row_id
		, m.member_allycode
		, m.member_name
		, m.member_power
		, m.member_power_characters
		, m.member_power_ships
		, IIF(m.member_ligue='0','CARBONITE',m.member_ligue) AS member_ligue
		, ms.total_omicrons_applied
		, ms.total_zetas_applied
		, ms.total_omegas_applied
		, ms.total_omicron_tw
		, ms.total_omicron_ga
		, ms.total_omicron_ga3x3
		, ms.total_omicron_tb
		, mr.characters_count
		, mr.ships_count
		, mr.legends_count
		, mr.relics_count
		, mr.r9_count
		, mr.r8_count
		, mr.r7_count
		, mr.r0_6_count
		, mr.g12_count
		, pp.avg_monthly_power
		, m.created_at AS join_date
		, fn.timestamp_date(m.updated) as updated_at
	FROM stage.members AS m
	INNER JOIN rules.members_skills AS ms ON m.member_allycode = ms.member_allycode
	INNER JOIN rules.members_roster AS mr ON m.member_allycode = mr.member_allycode
	INNER JOIN rules.power_progress AS pp ON m.member_allycode = pp.member_allycode
	INNER JOIN stage.members_current AS mc ON m.member_allycode = mc.member_allycode
GO