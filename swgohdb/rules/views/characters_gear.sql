USE swgoh
GO

CREATE OR ALTER VIEW rules.characters_gear
AS
	SELECT 
		cg.character_id
		, cg.gear_slot
		, cg.character_tier
		, g.gear_name
		, ISNULL(gp.gear_name, g.gear_name) AS gear_part_name
		, ISNULL(gr.amount, 1) AS amount
		, count(ISNULL(gr.gear_part_id, cg.gear_id)) over (partition by cg.character_id, cg.character_tier, cg.gear_slot) as gear_parts_count
		, g.gear_cost
	FROM (
		SELECT 
			character_id
			, character_tier
			, substring(gear_slot,12,1) as gear_slot
			, gear_id	
		FROM (
			SELECT character_id, character_tier, gear_slot_01
				, gear_slot_02, gear_slot_03, gear_slot_04
				, gear_slot_05, gear_slot_06
				from swgoh.stage.characters_gear
			) pvt
		UNPIVOT (
			gear_id FOR gear_slot in (
				gear_slot_01, gear_slot_02
				, gear_slot_03, gear_slot_04
				, gear_slot_05, gear_slot_06
				)
		) AS unpvt
	) AS cg 
	LEFT OUTER JOIN stage.gear_recipes AS gr ON gr.gear_id = cg.gear_id
	LEFT JOIN stage.gear AS g ON cg.gear_id = g.gear_id
	LEFT JOIN stage.gear AS gp ON gr.gear_part_id = gp.gear_id
GO