USE swgoh
GO

CREATE OR ALTER VIEW google.members
AS
	SELECT        
		m.member_name, m.member_allycode, m.member_ligue
		, m.member_fleet_rank
		, t.avg_tickets_lifetime, t.avg_tickets_month
		, t.avg_tickets_half_month, t.avg_tickets_week
		, m.member_power, pp.avg_monthly_power, m.member_power_characters
		, m.member_power_ships, mcr.legends_count
		, mcr.zetas_count, mo.omicrons_count
		, mcr.relics_count, mcr.r9_count, mcr.r8_count
		, mcr.r7_count, mcr.r0_6_count, mcr.g12_count
		, mcr.top_unit
		, mo.omicrons_ga5x5, mo.omicrons_ga3x3
		, mo.omicrons_tb, mo.omicrons_tw
		, cast(log_datetime as nvarchar(11)) as tickets_last_updated
		, round(cast(mods_speed_arrows as float)/mods_arrows,2) -- mods_arrows_score
			+ round(cast(mods_6_pips as float)/mods_total_count,2) * 3 -- mods_pips_6_score
			+ round(cast(mods_5_pips as float)/mods_total_count,2) -- mods_pips_5_score
			+ round(cast(mods_speed_count as float)/(mods_total_count-mods_speed_arrows),2) -- mods_speed_score
			+ round(cast(mods_speed_15_plus as float)/(mods_total_count-mods_speed_arrows),2) * 5 -- mods_speed_15_score
			+ round(cast(mods_speed_20_plus as float)/(mods_total_count-mods_speed_arrows),2) * 10 -- mods_speed_20_score
			+ round(cast(mods_speed_25_plus as float)/(mods_total_count-mods_speed_arrows),2) * 15 -- mods_speed_25_score
		AS mods_quality
	FROM stage.members AS m 
	INNER JOIN rules.members_roster AS mcr 
		ON m.member_allycode = mcr.member_allycode
	INNER JOIN hordeby.analise.members_omicrons AS mo 
		ON m.member_allycode = mo.member_allycode 
	LEFT OUTER JOIN rules.tickets AS t 
		ON t.member_name = m.member_name
	INNER JOIN stage.members_current mc on mc.member_allycode = m.member_allycode
	LEFT JOIN rules.power_progress pp on pp.member_allycode = m.member_allycode
	LEFT JOIN core.members_mods_total AS mods ON m.member_allycode = mods.member_allycode
	WHERE (m.member_current = 1)
GO