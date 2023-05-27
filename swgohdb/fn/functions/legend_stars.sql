USE swgoh
GO

CREATE OR ALTER FUNCTION fn.legend_stars (@stars int, @req_stars int)
RETURNS FLOAT
AS
BEGIN
	RETURN 
	CASE 
		WHEN @stars >= @req_stars THEN 1
		WHEN @req_stars - @stars = 1 THEN 0.5
		WHEN @req_stars - @stars = 2 THEN 0.25
		WHEN @req_stars - @stars = 3 THEN 0.1
		ELSE 0
	END
END
GO