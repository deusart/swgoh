USE swgoh
GO

CREATE OR ALTER FUNCTION fn.timestamp_date (@timestamp bigint)
RETURNS datetime
AS
BEGIN
	RETURN CAST(
			DATEADD(
				ms
				, CAST(RIGHT(@timestamp,3) AS SMALLINT)
				, DATEADD(s, @timestamp / 1000, '1970-01-01')
			) 
			AS DATETIME2(3)
			)

END
GO