USE swgoh
GO

CREATE OR ALTER VIEW core.gear_income
AS
	WITH cte_filter AS (
	SELECT 
		member_allycode
		, min(row_id) as min_row_id
		, max(row_id) as max_row_id
		, min(updated) as min_updated
		, max(updated) as max_updated
	FROM history.members_characters
	-- WHERE updated_at >= '2022-12-01' 
	GROUP BY member_allycode, character_id
	)
	, cte_state_min AS (
		SELECT 
			mc.member_allycode
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
		LEFT JOIN (
			SELECT r.* 
			FROM history.members_characters r 
			INNER JOIN cte_filter f 
				ON r.member_allycode = f.member_allycode
				AND f.min_row_id = r.row_id
			) AS mc	ON cg.character_id = mc.character_id 
	), cte_state_max AS (
		SELECT 
			mc.member_allycode
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
		LEFT JOIN (
			SELECT r.* 
			FROM history.members_characters r 
			INNER JOIN cte_filter f 
				ON r.member_allycode = f.member_allycode
				AND f.max_row_id = r.row_id
			) AS mc	ON cg.character_id = mc.character_id 
	)
	, cte_income AS (
		SELECT member_allycode, gear_part_name
			, sum(amount) as amount
			, DATEDIFF(
				DAY
				, (SELECT fn.timestamp_date(min(min_updated)) FROM cte_filter)
				, (SELECT fn.timestamp_date(max(max_updated)) FROM cte_filter)		
				) as days_count
			, ROUND(
				(
					CAST(sum(amount) AS float)
					/ 
					DATEDIFF(
						DAY
						, (SELECT fn.timestamp_date(min(min_updated)) FROM cte_filter)
						, (SELECT fn.timestamp_date(max(max_updated)) FROM cte_filter)		
						)
				) * 7
			, 0) AS weekly_income
		FROM (
			SELECT member_allycode, gear_part_name, sum(amount) AS amount
			FROM cte_state_max
			WHERE gear_ready = 1
			GROUP BY gear_part_name, member_allycode
			UNION ALL
			SELECT member_allycode, gear_part_name, -sum(amount) AS amount
			FROM cte_state_min
			WHERE gear_ready = 1
			GROUP BY gear_part_name, member_allycode
		) src
		GROUP BY gear_part_name, member_allycode
	)
	select member_allycode, gear_part_name, IIF(weekly_income = 0, 1, weekly_income) as weekly_income
	from cte_income
GO