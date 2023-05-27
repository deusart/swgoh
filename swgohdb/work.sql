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

UPDATE input.results_krayt
	SET score_max = 
		CASE
			WHEN score_first > score_01 AND score_first > score_02 AND score_first > score_03 THEN score_first
			WHEN score_01 > score_02 AND score_01 > score_03 THEN score_01
			WHEN score_02 > score_03 THEN score_02
			ELSE score_03
		END

INSERT INTO input.results_krayt (member_allycode,member_name)
SELECT member_allycode,member_name FROM stage.members
where fn.is_current(member_allycode)=1 and 
member_allycode not in (select member_allycode from input.results_krayt)