USE swgoh
GO

-- cheater_check
SELECT *
FROM [swgoh].[core].[cheats]
WHERE cheat_flag <> 0

-- guilds 
-- DELETE FROM stage.guilds WHERE created_at < '2023-04-03'
SELECT *
FROM stage.guilds
WHERE 1 = 1
AND guild_power < 120000000
AND ( 
		guild_string LIKE '%à%' OR guild_string LIKE '%ó%'		
		OR guild_string LIKE '%å%' OR guild_string LIKE '%û%'	
		OR guild_string LIKE '%î%' OR guild_string LIKE '%ý%'	
		OR guild_string LIKE '%è%' OR guild_string LIKE '%þ%'
	    OR guild_string LIKE '%ÿ%' OR guild_string LIKE '% RUS%'
	)

-- leftovers