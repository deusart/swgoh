USE swgoh
GO

CREATE OR ALTER VIEW core.members_history
AS
	SELECT 
		ROW_NUMBER() OVER (ORDER BY md.member_allycode, c.calendar_date) AS row_id
		, c.calendar_date
		, md.member_allycode
		, md.row_id AS member_row_id
	FROM core.calendar c
	CROSS JOIN (
		SELECT member_allycode, member_date, row_id 
			, LEAD(member_date) OVER (PARTITION BY src.member_allycode ORDER BY src.member_allycode, src.member_date) AS member_date_next
		FROM (
			SELECT 
				member_allycode
				, cast(updated_at as date) AS member_date
				, max(row_id) as row_id
			FROM history.members
			GROUP BY member_allycode, cast(updated_at as date)
		) src
	) md
	WHERE c.calendar_date BETWEEN member_date AND ISNULL(DATEADD(day,-1,member_date_next), member_date)
GO

