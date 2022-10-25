USE swgoh
GO

CREATE OR ALTER VIEW core.status_legends
AS
SELECT       
	member_allycode, legend_id
	, ROUND(
		SUM((gear_status + relic_status + stars_status) * unit_rarity) 
		/ SUM(unit_rarity * ready_total)
		, 4
	) AS completion
FROM rules.status_legends
WHERE fn.is_current(member_allycode) = 1
GROUP BY member_allycode, legend_id;
GO