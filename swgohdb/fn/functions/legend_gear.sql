USE swgoh
GO

CREATE OR ALTER FUNCTION fn.legend_gear (@gear int)
RETURNS FLOAT
AS
BEGIN
	RETURN 
	CASE
		WHEN @gear < 5 THEN 0
		WHEN @gear < 10 THEN 0.25
		WHEN @gear < 12 THEN 0.5
		WHEN @gear = 12 THEN 0.75
		WHEN @gear = 13 THEN 1
		ELSE 0
	END
END
GO