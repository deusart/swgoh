USE swgoh
GO

CREATE OR ALTER VIEW rules.status_legends
AS	
	SELECT
		smc.member_allycode
		, lr.legend_id
		, lr.unit_id
		, CASE
			WHEN lr.unit_type = 'ship' THEN 0
			WHEN lr.req_power = 0 THEN ISNULL(fn.legend_gear(mc.character_gear), 0)
			WHEN lr.req_power > 0 THEN 
				IIF(
					lr.req_power > mc.character_power
					, ROUND((CAST(mc.character_power as real) / lr.req_power), 2)
					, 1)		 	
		END AS gear_status
		, IIF( 
			lr.unit_type = 'character' and lr.req_power = 0
			, COALESCE(fn.legend_relic(mc.character_relic, lr.req_relic), 0)
			, 0
		) AS relic_status
		, IIF( 
			lr.unit_type = 'character'
			, ISNULL(fn.legend_stars(mc.character_stars, lr.req_stars),0)
			, ISNULL(fn.legend_stars(ms.ship_stars, lr.req_stars),0)
		) AS stars_status
		, CASE
			WHEN lr.unit_type = 'ship' THEN 1
			WHEN lr.unit_type = 'character' AND lr.req_power = 0 THEN 3
			WHEN lr.unit_type = 'character' AND lr.req_power > 0 THEN 2
		END AS ready_total
		, lr.unit_rarity
	FROM stage.members smc
	INNER JOIN  input.legend_requirements lr ON 1 = 1
	LEFT JOIN stage.members_characters mc on lr.unit_id = mc.character_id AND smc.member_allycode = mc.member_allycode
	LEFT JOIN stage.members_ships ms on lr.unit_id = ms.ship_id	 AND smc.member_allycode = ms.member_allycode
	WHERE smc.member_allycode > 0

GO


