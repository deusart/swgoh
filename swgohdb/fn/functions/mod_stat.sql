USE swgoh
GO

CREATE OR ALTER FUNCTION fn.mod_stat (@mod_stat int)
RETURNS NVARCHAR(50)
AS
BEGIN
	RETURN 
		CASE
			WHEN @mod_stat = 5 THEN 'Speed'
			WHEN @mod_stat = 16 THEN 'Crit Damage'
			WHEN @mod_stat = 48 THEN 'Offence'
			WHEN @mod_stat = 49 THEN 'Defence'
			WHEN @mod_stat = 55 THEN 'Health'
			WHEN @mod_stat = 56 THEN 'Protection'
			WHEN @mod_stat = 18 THEN 'Tenacity'
		ELSE 'Other'
		END
END
GO