USE swgoh
GO

CREATE OR ALTER VIEW rules.conquest
AS
	WITH cs AS (
		SELECT member_allycode, ROUND(CAST(SUM(ship_stars) AS float) / 7, 2) as conquest_score
		FROM swgoh.stage.members_ships
		WHERE ship_id IN ('RAZORCREST','TIEINTERCEPTOR','SCYTHE')
		GROUP BY member_allycode
		UNION ALL
		SELECT member_allycode, ROUND(CAST(SUM(character_stars) AS float) / 7, 2) as conquest_score	
		FROM swgoh.stage.members_characters
		WHERE character_id IN (
				'DARTHMALGUS','BENSOLO','COMMANDERAHSOKA'
				, 'MAULS7','BOBAFETTSCION', 'TRENCH'
				)
		GROUP BY member_allycode
	) 
	SELECT member_allycode, SUM(conquest_score) AS conquest_score
	FROM cs
	GROUP BY member_allycode
GO