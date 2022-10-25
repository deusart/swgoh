USE swgoh
GO

CREATE OR ALTER VIEW rules.progression
AS
	WITH cte AS (
		SELECT member_allycode
			  , legend_id
			  , MAX(row_id) AS max_row_id
			  , MIN(row_id) AS min_row_id
		FROM history.status_legends
		GROUP BY [member_allycode], [legend_id]
	)
	SELECT 
		cte.member_allycode
		, (SELECT TOP 1 member_name FROM stage.members where member_allycode = cte.member_allycode) AS member_name
		, cte.legend_id
		, CAST(slmin.created_at AS DATE) AS date_start
		, CAST(slmax.created_at AS DATE) AS date_end
		, slmin.completion AS completion_start
		, slmax.completion AS completion_end
		, slmax.completion - slmin.completion AS delta
		, IIF(slmax.completion = 1, 'COMPLETED', 'PROCESS') as current_status
		, IIF(cte.legend_id IN (SELECT DISTINCT legend_id FROM input.legend_requirements), 'LEGEND', 'JOURNEY') AS legend_type
	FROM cte
	LEFT JOIN history.status_legends slmin ON slmin.row_id = cte.min_row_id
	LEFT JOIN history.status_legends slmax ON slmax.row_id = cte.max_row_id
GO