USE swgoh
GO

CREATE OR ALTER VIEW rules.members_omicrons
AS
SELECT 
	member_allycode
	, sum(is_applied) as omicrons_count
	, sum(IIF(omicron_mode = 'GA', is_applied, 0)) as omicrons_ga5x5
	, sum(IIF(omicron_mode = 'GA3x3', is_applied, 0)) as omicrons_ga3x3
	, sum(IIF(omicron_mode = 'TB', is_applied, 0)) as omicrons_tb
	, sum(IIF(omicron_mode = 'TW', is_applied, 0)) as omicrons_tw
FROM rules.members_roster_omicrons
group by member_allycode