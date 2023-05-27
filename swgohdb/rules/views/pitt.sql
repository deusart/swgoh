USE swgoh
GO

CREATE OR ALTER VIEW rules.pitt
AS
	WITH pitt AS (
		SELECT member_allycode
			, COUNT(*) as r5_count	
			, SUM(
					IIF(
						character_id IN (
							'DARTHMALGUS','DARTHREVAN','BASTILASHANDARK'
							, 'DARTHMALAK','HK47', 'SITHMARAUDER'
							)
						, 1
						, 0
						)				
				) AS dr_score
			, SUM(IIF(character_id IN ('WATTAMBOR'), 1, 0)) AS wat_score
			, SUM(IIF(character_id IN ('SUPREMELEADERKYLOREN', 'GRANDMASTERLUKE', 'JEDIMASTERKENOBI', 'GLREY'), 1, 0)) AS gl_score 
			, SUM(
					IIF(
						character_id IN (
							'SHAAKTI','GENERALSKYWALKER','CT210408'
							, 'CT5555','CT7567', 'ARCTROOPER501ST'
							)
						, 1
						, 0
						)				
			) AS clones_score
			, SUM(
					IIF(
						character_id IN (
							'PADMEAMIDALA','AHSOKATANO','ANAKINKNIGHT'
							, 'GENERALKENOBI','C3POLEGENDARY', 'R2D2_LEGENDARY'
							)
						, 1
						, 0
						)				
			) AS padme_score
			, ISNULL((SELECT legends_count FROM core.members WHERE member_allycode = mc.member_allycode),0) as legend_count_score
		FROM swgoh.stage.members_characters mc
		WHERE character_relic >= 5
		GROUP BY member_allycode
	) 
	SELECT 
		member_allycode
		, ROUND(
			SUM(
				CAST(r5_count AS float)/20 
				+ CAST(dr_score AS float)/5
				+ CAST(wat_score AS float)
				+ CAST(gl_score AS float) / 2
				+ CAST(legend_count_score AS float) / 4
				+ CAST(clones_score AS float) / 5
				+ CAST(padme_score AS float) / 5
			)
		, 2) AS pitt_score
	FROM pitt
	GROUP BY member_allycode
GO