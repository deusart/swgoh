USE swgoh
GO

CREATE OR ALTER VIEW core.members_score
AS
	WITH members AS (
		SELECT 
			member_allycode
			, member_name
			, ROUND(CAST(member_power AS float)/1000000,2) AS power_score
			, member_skillrating
			, CASE 
				WHEN member_ligue = 'KYBER' THEN 3
				WHEN member_ligue = 'AURODIUM' THEN 2
				WHEN member_ligue = 'CHROMIUM' THEN 1
				WHEN member_ligue = 'BRONZIUM' THEN 0.5
				WHEN member_ligue = 'CARBONITE' THEN 0
			END AS ligue_score
			, 
			(
				SELECT 
					CASE 
						WHEN MIN(member_fleet_rank) BETWEEN 1 AND 10 THEN CAST(5 AS float)
						WHEN MIN(member_fleet_rank) BETWEEN 10 AND 25 THEN CAST(3 AS float)
						WHEN MIN(member_fleet_rank) BETWEEN 25 AND 50 THEN CAST(2 AS float)
						WHEN MIN(member_fleet_rank) BETWEEN 50 AND 75 THEN CAST(1 AS float)
						WHEN MIN(member_fleet_rank) BETWEEN 75 AND 100 THEN CAST(0.5 AS float)
						WHEN MIN(member_fleet_rank) BETWEEN 100 AND 115 THEN CAST(0.25 AS float)
						ELSE 0
					END AS fleet_rank_score
				FROM swgoh.archive.daily_members
				WHERE EOMONTH(log_date) = EOMONTH(GETDATE()) AND member_allycode = m.member_allycode
			) AS fleet_rank_score
			, CASE 
				WHEN member_arena_rank BETWEEN 1 AND 50 THEN 3
				WHEN member_arena_rank BETWEEN 50 AND 100 THEN 2
				WHEN member_arena_rank BETWEEN 100 AND 200 THEN 1
				WHEN member_arena_rank BETWEEN 200 AND 500 THEN 0.5
				ELSE 0
			END AS arena_rank_score
			, ROUND(CAST(total_omicrons_applied AS float)/5,2) AS omicron_score
			, ROUND(CAST(total_zetas_applied AS float)/50,2) AS zetas_score
			, ROUND(CAST(total_relic_levels as float)/100 ,2)
				 + IIF(relics_count > 0
					, ROUND(CAST(r9_count as float) * 3 / relics_count, 2)
					+ ROUND(CAST(r8_count as float) * 2 / relics_count, 2)
					+ ROUND(CAST(r7_count as float) * 1.5 / relics_count, 2)
					+ ROUND(CAST(r0_6_count as float) / relics_count, 2)
					, 0
				)
				+ ROUND(CAST(r9_count as float) / 10, 2)
				+ ROUND(CAST(r8_count as float) / 20, 2)
				+ ROUND(CAST(relics_count as float) / 100, 2)
			AS relic_score			
			, legends_count * 3 AS legend_count_score						
		FROM core.members m
	)
	, members_mods AS (
		SELECT member_allycode
			, round(cast(mods_speed_arrows as float)/mods_arrows,2) -- mods_arrows_score
			+ round(cast(mods_6_pips as float)/mods_total_count,2) * 3 -- mods_pips_6_score
			+ round(cast(mods_5_pips as float)/mods_total_count,2) -- mods_pips_5_score
			+ round(cast(mods_speed_count as float)/(mods_total_count-mods_speed_arrows),2) -- mods_speed_score
			+ round(cast(mods_speed_15_plus as float)/(mods_total_count-mods_speed_arrows),2) * 5 -- mods_speed_15_score
			+ round(cast(mods_speed_20_plus as float)/(mods_total_count-mods_speed_arrows),2) * 10 -- mods_speed_20_score
			+ round(cast(mods_speed_25_plus as float)/(mods_total_count-mods_speed_arrows),2) * 15 -- mods_speed_25_score
			AS mods_score
		FROM core.members_mods_total
	)
	, roster_legend AS (
		SELECT member_allycode
			, (CAST(SUM(character_gear) AS float)/10 + + SUM(zetas_applied) + SUM(character_relic))/10 as legend_gear_score
		FROM core.members_characters mc
		INNER JOIN stage.characters c ON mc.character_id = c.character_id
		WHERE fn.is_current(member_allycode) = 1 AND c.character_tags like '%legend%'
		GROUP BY member_allycode
	)	
	, journey AS (
		SELECT member_allycode
			, ROUND(SUM(journey_status)/5,2) AS journey_score
		FROM core.status_journeys
		GROUP BY member_allycode
	)	
	, legends AS (
		SELECT member_allycode
			, ROUND(SUM(completion),2) AS legend_score
		FROM core.status_legends
		GROUP BY member_allycode
	)	
	, power_progress AS (
		SELECT member_allycode
			, ROUND(CAST(avg_monthly_power AS float)/100000,2) AS power_progress_score
		FROM rules.power_progress
	)
	, tickets AS (
		SELECT member_name,  ROUND(CAST(avg_tickets_lifetime as float) / 50, 2) AS tickets_score
		FROM rules.tickets
	)
	, relics AS (
		SELECT 
			(SELECT member_allycode FROM swgohdv.core.h_members WHERE member_hkey = r.member_hkey) AS member_allycode
			, ROUND(
				CAST((MAX(member_relics) - MIN(member_relics)) AS float) / DATEDIFF(MONTH, MIN(record_date), MAX(record_date))
				,2
			) AS relic_progress_score
			, ROUND(
				CAST((MAX(member_relic_levels) - MIN(member_relic_levels)) AS float) / (DATEDIFF(MONTH, MIN(record_date), MAX(record_date))*3)
				,2
			) AS relic_level_score
		FROM swgohdv.core.s_members_relics r
		GROUP BY member_hkey
		HAVING DATEDIFF(MONTH, MIN(record_date), MAX(record_date)) > 0
	)	
	, fleet AS (
		SELECT 
			member_allycode
			, ROUND(
				CAST(SUM(IIF(ship_id IN ('CAPITALEXECUTOR','CAPITALPROFUNDITY'), ship_stars,0)) AS float) / 3
				+ CAST(SUM(IIF(ship_id IN ('CAPITALNEGOTIATOR','CAPITALMALEVOLENCE'), ship_stars,0)) AS float) / 6
				+ CAST(SUM(IIF(ship_id IN ('CAPITALRADDUS','CAPITALFINALIZER'), ship_stars,0)) AS float) / 9
				+ CAST(SUM(IIF(ship_id like '%capital%', ship_stars, 0)) AS float) / 25
				+ CAST(SUM(IIF(ship_stars = 7, 1, 0)) AS float) / 25
			, 2) AS fleet_score
		FROM swgoh.stage.members_ships
		GROUP BY member_allycode
	)
	, fleet_rank AS (
		SELECT member_allycode
			, CASE 
				WHEN MIN(member_fleet_rank) BETWEEN 1 AND 10 THEN CAST(5 AS float)
				WHEN MIN(member_fleet_rank) BETWEEN 10 AND 25 THEN CAST(3 AS float)
				WHEN MIN(member_fleet_rank) BETWEEN 25 AND 50 THEN CAST(2 AS float)
				WHEN MIN(member_fleet_rank) BETWEEN 50 AND 75 THEN CAST(1 AS float)
				WHEN MIN(member_fleet_rank) BETWEEN 75 AND 100 THEN CAST(0.5 AS float)
				WHEN MIN(member_fleet_rank) BETWEEN 100 AND 115 THEN CAST(0.25 AS float)
				ELSE 0
			END AS fleet_rank_score
		FROM swgoh.archive.daily_members
		WHERE EOMONTH(log_date) = EOMONTH(GETDATE()) 
		GROUP BY member_allycode
	)
	SELECT 
		m.member_allycode
		, m.member_name 
		, ROUND(
			power_score
			+ mm.mods_score
			+ COALESCE(m.ligue_score,0) + COALESCE(CAST(m.member_skillrating AS float),0)/1000
			+ COALESCE(fr.fleet_rank_score,m.fleet_rank_score)
			+ m.omicron_score
			+ m.zetas_score
			+ m.relic_score
			+ m.legend_count_score + ISNULL(legend_gear_score,0)
			+ j.journey_score
			+ l.legend_score
			+ m.arena_rank_score
			+ f.fleet_score
			+ ISNULL(pp.power_progress_score,0)
			+ ISNULL(tt.tickets_score,0)
			+ ISNULL(r.relic_progress_score,0)
			+ ISNULL(r.relic_level_score,0)
			+ ISNULL(gd.geo_score,0)
			+ ISNULL(c.conquest_score,0)
			+ ISNULL(
				CAST(datacrons_9 * 0.5 + datacrons_8 * 0.35 + datacrons_7 * 0.32
				+ datacrons_6 * 0.3 + datacrons_5 * 0.15 + datacrons_4 * 0.12
				+ datacrons_3 * 0.1 + datacrons_2 * 0.05 + datacrons_1 * 0.02
				AS float), 0)
			, 2)
		AS total_score
		, m.power_score
		, ROUND(mm.mods_score, 2) AS mods_score
		, COALESCE(ROUND(CAST(m.ligue_score AS float), 2) + COALESCE(CAST(m.member_skillrating AS float),0)/1000,0) AS gac_score
		, ROUND(COALESCE(fr.fleet_rank_score, m.fleet_rank_score), 2) AS fleet_rank_score
		, ROUND(CAST(m.omicron_score AS float), 2) AS omicron_score
		, ROUND(CAST(m.zetas_score AS float), 2) AS zetas_score
		, ROUND(CAST(m.relic_score AS float), 2) AS relic_score
		, ROUND(m.legend_count_score + ISNULL(legend_gear_score,0), 2) AS legend_count_score
		, j.journey_score
		, l.legend_score
		, ROUND(CAST(m.arena_rank_score AS float), 2) AS arena_rank_score
		, f.fleet_score
		, ISNULL(pp.power_progress_score,0) AS power_progress_score
		, ISNULL(tt.tickets_score,0) AS tickets_score
		, ISNULL(r.relic_progress_score,0) AS relic_progress_score
		, ISNULL(r.relic_level_score,0) AS relic_level_score
		, CAST(ISNULL(gd.geo_score,0) AS float) AS geods_score
		, CAST(ISNULL(c.conquest_score,0) AS float) AS conquest_score
		, ISNULL(
			CAST(datacrons_9 * 0.5 + datacrons_8 * 0.35 + datacrons_7 * 0.32
			+ datacrons_6 * 0.3 + datacrons_5 * 0.15 + datacrons_4 * 0.12
			+ datacrons_3 * 0.1 + datacrons_2 * 0.05 + datacrons_1 * 0.02
			AS float), 0) AS datacron_score
	FROM members m
	INNER JOIN members_mods mm ON m.member_allycode = mm.member_allycode
	INNER JOIN journey j ON m.member_allycode = j.member_allycode
	INNER JOIN legends l ON m.member_allycode = l.member_allycode
	INNER JOIN fleet f ON m.member_allycode = f.member_allycode
	LEFT JOIN roster_legend rl ON m.member_allycode = rl.member_allycode
	LEFT JOIN rules.geods gd ON m.member_allycode = gd.member_allycode
	LEFT JOIN rules.conquest c ON m.member_allycode = c.member_allycode
	LEFT JOIN relics r ON m.member_allycode = r.member_allycode
	LEFT JOIN power_progress pp ON m.member_allycode = pp.member_allycode
	LEFT JOIN tickets tt ON m.member_name = tt.member_name
	LEFT JOIN stage.members_datacrons d ON m.member_allycode = d.member_allycode
	LEFT JOIN fleet_rank fr ON m.member_allycode = fr.member_allycode
GO