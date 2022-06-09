USE swgoh
GO

CREATE OR ALTER VIEW google.members
AS
SELECT        
	m.member_name, m.member_allycode, m.member_ligue
	, t.avg_tickets_lifetime, t.avg_tickets_month
	, m.member_power, m.member_power_characters
	, m.member_power_ships, mcr.legend_count
	, mcr.zetas_count, mo.omicrons_count
	, mcr.relics_count, mcr.r9_count, mcr.r8_count
	, mcr.r7_count, mcr.r0_6_count, mcr.g12_count
	, mcr.top_unit
	, mo.omicrons_ga5x5, mo.omicrons_ga3x3
	, mo.omicrons_tb, mo.omicrons_tw
	, cast(log_datetime as nvarchar(11)) as tickets_last_updated
FROM hordeby.stage.members AS m 
INNER JOIN hordeby.rules.members_roster AS mcr 
	ON m.member_allycode = mcr.member_allycode
INNER JOIN hordeby.analise.members_omicrons AS mo 
	ON m.member_allycode = mo.member_allycode 
LEFT OUTER JOIN rules.tickets AS t 
	ON t.member_name = m.member_name
INNER JOIN stage.members_current mc on mc.member_allycode = m.member_allycode
WHERE (m.member_current = 1)
GO