USE swgoh
GO

CREATE OR ALTER VIEW core.members_characters_gear
AS
	SELECT 
		m.member_allycode
		, cg.character_id
		, cg.character_tier
		, cg.gear_slot
		, cg.gear_name
		, cg.gear_part_name 
		, cg.amount
		, cg.gear_parts_count
		, cg.gear_cost
		, COALESCE(case 
			when mc.character_gear > cg.character_tier then 1
			when mc.character_gear < cg.character_tier then 0
			when mc.character_gear = cg.character_tier 
				then 
				case 
					when cg.gear_slot = 1 then mc.gear_slot_01
					when cg.gear_slot = 2 then mc.gear_slot_02
					when cg.gear_slot = 3 then mc.gear_slot_03
					when cg.gear_slot = 4 then mc.gear_slot_04
					when cg.gear_slot = 5 then mc.gear_slot_05
					when cg.gear_slot = 6 then mc.gear_slot_06
					else 0
				end
		end, 0) AS gear_ready
	FROM rules.characters_gear AS cg 
	CROSS JOIN (
		SELECT member_allycode
		FROM stage.members
	) m
	LEFT JOIN stage.members_characters AS mc
		ON cg.character_id = mc.character_id and m.member_allycode = mc.member_allycode
GO