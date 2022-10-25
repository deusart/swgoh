USE swgoh
GO

CREATE OR ALTER FUNCTION fn.legend_relic (@relic int, @req_relic int)
RETURNS FLOAT
AS
BEGIN
	RETURN 	
	CASE 
		WHEN @relic >= @req_relic THEN 1
		WHEN @req_relic > 8 THEN
			CASE
				WHEN @relic = 8 THEN 0.5
				WHEN @relic = 7 THEN 0.4
				WHEN @relic = 6 THEN 0.3
				WHEN @relic = 5 THEN 0.2
				WHEN @relic = 4 THEN 0.1
				WHEN @relic = 3 THEN 0.05
			END
		WHEN @req_relic > 7 THEN
			CASE
				WHEN @relic = 7 THEN 0.75
				WHEN @relic = 6 THEN 0.5
				WHEN @relic = 5 THEN 0.4
				WHEN @relic = 4 THEN 0.3
				WHEN @relic = 3 THEN 0.2
				WHEN @relic = 2 THEN 0.1
				WHEN @relic = 1 THEN 0.05
			END
		WHEN @req_relic > 5 THEN
			CASE 
				WHEN @relic = 6 THEN 0.75
				WHEN @relic = 5 THEN 0.5
				WHEN @relic = 4 THEN 0.4
				WHEN @relic = 3 THEN 0.3
				WHEN @relic = 2 THEN 0.2
				WHEN @relic = 1 THEN 0.1
			END
		WHEN @req_relic > 3 THEN
			CASE 
				WHEN @relic = 4 THEN 0.75
				WHEN @relic = 3 THEN 0.5
				WHEN @relic = 2 THEN 0.25
				WHEN @relic = 1 THEN 0.15
			END
		WHEN @req_relic = 3 THEN
			CASE 
				WHEN @relic = 2 THEN 0.5
				WHEN @relic = 1 THEN 0.25
			END
		ELSE 0
	END
END
GO