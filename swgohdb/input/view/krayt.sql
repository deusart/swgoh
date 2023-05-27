USE swgoh
GO

CREATE OR ALTER VIEW input.krayt
AS
	SELECT 
		member_name
		, score_first
		, score_01
		, score_02
		, score_03
	FROM input.results_krayt
GO

CREATE OR ALTER TRIGGER input.results_krayt_update
   ON input.results_krayt
   AFTER UPDATE
AS 
BEGIN
	UPDATE input.results_krayt
	SET score_max = 
		CASE
			WHEN score_first > score_01 AND score_first > score_02 AND score_first > score_03 THEN score_first
			WHEN score_01 > score_02 AND score_01 > score_03 THEN score_01
			WHEN score_02 > score_03 THEN score_02
			ELSE score_03
		END
END