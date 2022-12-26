USE swgoh
GO

CREATE OR ALTER VIEW core.members_mods_total
AS
	SELECT 
		member_allycode
		, fn.member_name(member_allycode) AS member_name
		, SUM(IIF(mod_pips=6,1,0)) AS mods_6_pips
		, SUM(IIF(mod_pips=5,1,0)) AS mods_5_pips
		, SUM(IIF(mod_pips<5,1,0)) AS mods_low_pips
		, SUM(IIF(mod_secondary_speed > 0, 1, 0)) AS mods_speed_count
		, SUM(IIF(mod_secondary_speed BETWEEN 15 AND 19, 1, 0)) AS mods_speed_15_plus
		, SUM(IIF(mod_secondary_speed BETWEEN 20 AND 24, 1, 0)) AS mods_speed_20_plus
		, SUM(IIF(mod_secondary_speed >= 25, 1, 0)) AS mods_speed_25_plus
		, SUM(IIF(is_arrow=1 AND mod_primary_stat = 'Speed', 1 , 0)) AS mods_speed_arrows
		, SUM(IIF(is_arrow=1 AND mod_primary_stat != 'Speed', 1 , 0)) AS mods_not_speed_arrows
		, SUM(IIF(is_arrow=1 AND mod_secondary_speed >= 15, 1 , 0)) AS mods_secondary_speed_arrows
		, COUNT(*) AS mods_total_count
		, SUM(IIF(is_arrow=1, 1 , 0)) AS mods_arrows
	FROM [swgoh].[core].[members_mods]
	GROUP BY member_allycode
GO