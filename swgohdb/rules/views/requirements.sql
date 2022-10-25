USE swgoh
GO

CREATE OR ALTER VIEW rules.requirements
AS	
	WITH legend AS (
		SELECT 
			lr.legend_id
			, unit_id
			, req_relic
			, 13 AS req_gear
		FROM input.legend_requirements lr
		WHERE lr.unit_type = 'character' 
	),
	joyrney AS (
		SELECT DISTINCT
			journey_id
			, unit_id
			, req_relic
			, IIF(req_relic = 0, 12, 13) AS req_gear
		FROM input.journey_requirements
		WHERE journey_id IN (
			'STARKILLER'
			, 'GENERALSKYWALKER'
			, 'JEDIKNIGHTLUKE'
			, 'GRANDINQUISITOR'
		) AND unit_type = 'special_unit'
	),
	legend_joyrney AS (
		SELECT 
			l.legend_id
			, j.unit_id
			, j.req_relic
			, j.req_gear
		FROM legend l
		INNER JOIN joyrney j ON l.unit_id = j.journey_id
		WHERE j.unit_id NOT IN (
			SELECT unit_id 
			FROM input.legend_requirements 
			WHERE legend_id = l.legend_id
			)
	)
	SELECT * FROM legend
	UNION
	SELECT * FROM legend_joyrney
	UNION
	SELECT * FROM joyrney
GO


