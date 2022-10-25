USE swgoh
GO

CREATE OR ALTER VIEW core.gac_seasons
AS
	SELECT TOP 100 PERCENT
		ROW_NUMBER() OVER (partition by 1 order by gac_end_time) as row_season_id
		, season_id
		, event_id
		, CAST(SUBSTRING(event_id, CHARINDEX('SEASON', event_id)+7, 2) AS INT) as season_num
		, IIF(season_id like '%_5v5_%','5x5','3x3') AS gac_type
		, cast(fn.timestamp_date(SUBSTRING(event_id, CHARINDEX(':O', event_id)+2, 13)) as date) as gac_season_start		
		, cast(fn.timestamp_date(gac_end_time) as date) as gac_season_end
	FROM swgoh.stage.members_gac
	group by season_id, event_id, gac_end_time
	order by gac_end_time
GO