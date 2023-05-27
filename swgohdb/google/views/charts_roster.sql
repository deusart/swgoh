USE swgoh
GO

CREATE OR ALTER VIEW google.charts
AS
	WITH base AS (
		SELECT 
			member_allycode
			, YEAR(created_at)*100+MONTH(created_at) as year_month
		FROM swgoh.history.members_current
		WHERE created_at IN (
			SELECT MAX(created_at) AS max_date
			FROM swgoh.history.members_current
			GROUP BY YEAR(created_at)*100+MONTH(created_at)
		)
	)
	SELECT 
		b.member_allycode, b.year_month
		, MAX(m.member_power) AS member_power
		, MAX(m.log_date) AS log_date
		, MAX(m.member_relics) AS member_relics
		, MAX(m.member_legends) AS member_legends
		, MAX(m.member_omicrons) AS member_omicrons
		, (SELECT member_ligue FROM archive.daily_members WHERE row_id = MAX(m.row_id)) AS member_ligue
	FROM base b
	INNER JOIN archive.daily_members m ON b.member_allycode = m.member_allycode AND b.year_month = YEAR(m.log_date)*100+MONTH(m.log_date)
	GROUP BY  b.member_allycode, b.year_month
GO

