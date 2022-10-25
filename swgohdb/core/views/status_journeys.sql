USE swgoh
GO

CREATE OR ALTER VIEW core.status_journeys
AS	
	SELECT
		m.member_allycode
		, m.member_name
		, journey_id
		, IIF(
			mc.character_id IS NOT NULL AND mc.character_stars = 7
			, 1
			, ROUND(
				SUM(
					(
						stars_status 
						+ power_status 
						+ gear_status
						+ relic_status
					) * unit_rarity
				) 
				/ SUM(unit_rarity * total_status)
				, 4
			)
		) AS journey_status
	FROM (
		SELECT * FROM rules.status_journeys_ships
		UNION ALL
		SELECT * FROM rules.status_journeys_characters
	) js
	INNER JOIN core.members m ON m.member_allycode = js.member_allycode
	LEFT JOIN core.members_characters mc ON js.journey_id = character_id AND mc.member_allycode = js.member_allycode
	GROUP BY m.member_allycode, journey_id, m.member_name, mc.character_id, mc.character_stars  
GO