USE swgoh
GO

CREATE OR ALTER VIEW core.gac_history
AS
	SELECT 
		m.member_name
		, m.member_allycode
		, m.member_ligue as current_ligue
		, SUM(IIF(row_season_id = 1, gac_banners, 0)) AS gac_banners_gac30
		, MAX(IIF(row_season_id = 1, mg.gac_ligue, NULL)) as ligue_gac30
		, SUM(IIF(row_season_id = 2, gac_banners, 0)) AS gac_banners_gac31
		, MAX(IIF(row_season_id = 2, mg.gac_ligue, NULL)) as ligue_gac31
		, SUM(IIF(row_season_id = 3, gac_banners, 0)) AS gac_banners_gac32
		, MAX(IIF(row_season_id = 3, mg.gac_ligue, NULL)) as ligue_gac32
		, SUM(IIF(row_season_id = 4, gac_banners, 0)) AS gac_banners_gac33
		, MAX(IIF(row_season_id = 4, mg.gac_ligue, NULL)) as ligue_gac33
		, SUM(IIF(row_season_id = 5, gac_banners, 0)) AS gac_banners_gac34
		, MAX(IIF(row_season_id = 5, mg.gac_ligue, NULL)) as ligue_gac34
		, SUM(IIF(row_season_id = 6, gac_banners, 0)) AS gac_banners_gac35
		, MAX(IIF(row_season_id = 6, mg.gac_ligue, NULL)) as ligue_gac35
		, SUM(IIF(row_season_id = 7, gac_banners, 0)) AS gac_banners_gac36
		, MAX(IIF(row_season_id = 7, mg.gac_ligue, NULL)) as ligue_gac36
		, SUM(IIF(row_season_id = 8, gac_banners, 0)) AS gac_banners_gac37
		, MAX(IIF(row_season_id = 8, mg.gac_ligue, NULL)) as ligue_gac37
		, SUM(IIF(row_season_id = 9, gac_banners, 0)) AS gac_banners_gac38
		, MAX(IIF(row_season_id = 9, mg.gac_ligue, NULL)) as ligue_gac38
		, SUM(IIF(row_season_id = 10, gac_banners, 0)) AS gac_banners_gac39
		, MAX(IIF(row_season_id = 10, mg.gac_ligue, NULL)) as ligue_gac39
		, SUM(IIF(row_season_id = 11, gac_banners, 0)) AS gac_banners_gac40
		, MAX(IIF(row_season_id = 11, mg.gac_ligue, NULL)) as ligue_gac40
		, SUM(IIF(row_season_id = 12, gac_banners, 0)) AS gac_banners_gac41
		, MAX(IIF(row_season_id = 12, mg.gac_ligue, NULL)) as ligue_gac41
	FROM core.gac_seasons gs
	INNER JOIN stage.members_gac as mg on gs.season_id = mg.season_id
	INNER JOIN stage.members m on mg.member_allycode = m.member_allycode
	group by m.member_name, m.member_allycode, m.member_ligue
GO

