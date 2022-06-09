USE swgoh
GO

CREATE OR ALTER VIEW google.gvg_ligue
AS
SELECT 
		l.ligue
		, CASE 
			WHEN 
				isnull(ml.member_count,0) 
				> 
				isnull(ol.opponent_count,0) 
			THEN
				'Мы сильнее'
			WHEN 
				isnull(ml.member_count,0)  
				< 
				isnull(ol.opponent_count,0) 
			THEN
				'Мы слабее'
			ELSE
				'Равны'
		END AS analitics
		, isnull(ml.member_count, 0) AS member_count
		, isnull(ml.member_power, 0) AS member_power
		, isnull(ol.opponent_count, 0) AS opponent_count
		, isnull(ol.opponent_power, 0) AS opponent_power
		, isnull(ml.member_count, 0) - isnull(ol.opponent_count, 0) AS delat_count
		, isnull(ml.member_power, 0) - isnull(ol.opponent_power, 0) AS delat_power
	FROM (
		SELECT 'KYBER' AS ligue
		UNION ALL SELECT 'AURODIUM' AS ligue
		UNION ALL SELECT 'CHROMIUM' AS ligue
		UNION ALL SELECT 'BRONZIUM' AS ligue
		UNION ALL SELECT 'CARBONITE' AS ligue
	) l
	LEFT JOIN (
		SELECT
			member_ligue
			, count(member_allycode) as member_count
			, sum(member_power) as member_power
		FROM stage.members
		WHERE member_allycode IN (
			SELECT member_allycode
			FROM stage.members_current
		)
		GROUP BY member_ligue
	) ml ON ml.member_ligue= l.ligue
	LEFT JOIN (
		SELECT
			opponent_ligue
			, count(opponent_allycode) as opponent_count
			, sum(opponent_power) as opponent_power
		from stage.opponents
		group by opponent_ligue
	) ol ON ol.opponent_ligue = l.ligue
GO