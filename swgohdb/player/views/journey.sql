USE swgoh
GO

CREATE OR ALTER VIEW player.journey
AS
	WITH characters AS (
		SELECT 
			r.legend_id
			, r.unit_id AS character_id
			, r.req_relic
			, c.character_relic
			, c.character_stars
			, (
				SELECT sum(level_cost)
				FROM fn.levels
				WHERE level_number > c.character_level
			) AS level_cost
			, ISNULL(
				(
					SELECT sum(star_cost)
					FROM fn.stars st
					INNER JOIN stage.characters sc ON st.star_shards > sc.character_shards
					WHERE star_number >  c.character_stars AND sc.character_id = c.character_id
				), 0
			) AS star_cost		
		FROM rules.requirements r
		LEFT JOIN player.characters c ON r.unit_id = c.character_id
	),
	gear AS (
		SELECT DISTINCT character_id
		, SUM(IIF(gear_part_name like 'Injector Cell Salvage%', amount, 0)) as injector_cell
		, SUM(IIF(gear_part_name like 'Injector Handle Salvage%', amount, 0)) as injector_handle
		, SUM(IIF(gear_part_name like 'Injector Head Salvage%', amount, 0)) as injector_head
		, SUM(IIF(gear_part_name like 'Mk 3 Carbanti%', amount, 0)) as mk3_carbanti
		, SUM(IIF(gear_part_name like '%Mk 3 Czerka Stun Cuffs Salvage%', amount, 0)) as mk3_cuffs
		, SUM(IIF(gear_part_name like '%Mk 8 BioTech Implant Salvage%', amount, 0)) as mk8_biotech
		, SUM(IIF(gear_part_name like '%Mk 7 Kyrotech Shock Prod Prototype Salvage%', amount, 0)) as kyrotechs_shoks
		, SUM(IIF(gear_part_name like '%Mk 9 Kyrotech Battle Computer Prototype Salvage%', amount, 0)) as kyrotechs_computers
		, SUM(IIF(gear_part_name like '%Mk 6 Athakam Medpac Salvage%', amount, 0)) as mk6_medpacks
		, SUM(IIF(gear_part_name like '%Mk 8 Nubian Security Scanner Salvage%', amount, 0)) as mk8_scanner
		, SUM(IIF(gear_part_name like '%Mk 4 Zaltin Bacta Gel Salvage%', amount, 0)) as mk4_zaltin
		, SUM(IIF(gear_part_name like '%Mk 6 Arakyd Droid Caller Salvage%', amount, 0)) as mk6_arakyd
		, SUM(IIF(gear_part_name like '%Mk 12 ArmaTek Medpac Prototype Salvage%', amount, 0)) as g12_medpack
		, SUM(IIF(gear_part_name like '%Mk 12 ArmaTek Multi-tool Prototype Salvage%', amount, 0)) as g12_multitool
		, SUM(IIF(gear_part_name like '%Mk 12 ArmaTek Data Pad Prototype Salvage%', amount, 0)) as g12_datapad
		, SUM(IIF(gear_part_name like '%Mk 12 ArmaTek Fusion Furnace Prototype Salvage%', amount, 0)) as g12_fusion
		, SUM(IIF(gear_part_name like '%Mk 12 ArmaTek Holo Lens Prototype Salvage%', amount, 0)) as g12_holo
		FROM rules.requirements r
		INNER JOIN player.gear g 
			ON r.unit_id = g.character_id 
				AND g.character_tier < r.req_gear
		WHERE gear_ready = 0
		GROUP BY character_id
	),
	relics AS (
		SELECT  
			c.character_id
			, SUM(relic_cost) AS relic_cost
			, SUM(fragmented_signal_data) AS fragmented_signal_data
			, SUM(incomplete_signal_data) AS incomplete_signal_data
			, SUM(flawed_signal_data) AS flawed_signal_data
			, SUM(carbonite_circuit_board) AS carbonite_circuit_board
			, SUM(bronzium_wiring) AS bronzium_wiring
			, SUM(chromium_transistor) AS chromium_transistor
			, SUM(aurodium_heatsink) AS aurodium_heatsink
			, SUM(electrium_conductor) AS electrium_conductor
			, SUM(zinbiddle_card) AS zinbiddle_card
			, SUM(impulse_detector) AS impulse_detector
			, SUM(aeromagnifier) AS aeromagnifier
			, SUM(gyrda_keypad) AS gyrda_keypad
			, SUM(droid_brain) AS droid_brain
		FROM rules.requirements r
		INNER JOIN player.characters c ON r.unit_id = c.character_id
		INNER JOIN fn.relics rl ON r.req_relic >= rl.relic_number AND rl.relic_number > c.character_relic
		GROUP BY c.character_id
	),
	gear_total AS (
		SELECT character_id
		  , sum(amount) AS gear_count_total
		FROM rules.requirements r
		INNER JOIN player.gear g 
			ON r.unit_id = g.character_id
		GROUP BY character_id
	),
	gear_needed AS (
		SELECT character_id
		  , sum(amount) AS gear_count_needed
		  , sum(gear_cost) AS gear_cost_needed
		FROM rules.requirements r
		INNER JOIN player.gear g 
			ON r.unit_id = g.character_id
		WHERE gear_ready = 0
		GROUP BY character_id
	)
	SELECT
		c.*
		, gt.gear_count_total
		, gn.gear_count_needed
		, gn.gear_cost_needed
		, g.injector_cell
		, g.injector_handle
		, g.injector_head
		, g.mk3_carbanti
		, g.mk3_cuffs
		, g.mk8_biotech
		, g.kyrotechs_shoks
		, g.kyrotechs_computers
		, g.mk6_medpacks
		, g.mk8_scanner
		, g.mk4_zaltin
		, g.mk6_arakyd
		, g.g12_medpack
		, g.g12_multitool
		, g.g12_datapad
		, g.g12_fusion
		, g.g12_holo
		, relic_cost
		, fragmented_signal_data
		, incomplete_signal_data
		, flawed_signal_data
		, carbonite_circuit_board
		, bronzium_wiring
		, chromium_transistor
		, aurodium_heatsink
		, electrium_conductor
		, zinbiddle_card
		, impulse_detector
		, aeromagnifier
		, gyrda_keypad
		, droid_brain
	FROM characters c
	LEFT JOIN gear_needed gn ON c.character_id = gn.character_id
	LEFT JOIN gear_total gt ON c.character_id = gt.character_id 
	LEFT JOIN gear g ON c.character_id = g.character_id 
	LEFT JOIN relics r ON c.character_id = r.character_id
GO