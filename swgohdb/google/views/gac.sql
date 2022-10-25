USE swgoh
GO

CREATE OR ALTER VIEW google.gac
AS
SELECT        
	m.member_name, m.member_allycode, m.member_ligue
	, concat('https://swgoh.gg/p/',m.member_allycode,'/gac-bracket/') AS gac_bucket
	, concat('https://swgoh.gg/p/',m.member_allycode,'/gac-history/') AS gac_history
	, m.member_power, pp.avg_monthly_power
	, mcr.zetas_count, mcr.relics_count
	, mo.omicrons_ga5x5, mo.omicrons_ga3x3	
FROM stage.members AS m 
INNER JOIN rules.members_roster AS mcr 
	ON m.member_allycode = mcr.member_allycode
INNER JOIN hordeby.analise.members_omicrons AS mo ON m.member_allycode = mo.member_allycode 
INNER JOIN stage.members_current mc on mc.member_allycode = m.member_allycode
INNER JOIN rules.power_progress pp on pp.member_allycode = m.member_allycode
WHERE (m.member_current = 1)
GO

