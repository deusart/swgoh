USE swgoh
GO

CREATE OR ALTER FUNCTION fn.mk (@gear_name nvarchar(max))
RETURNS nvarchar(6)
AS
BEGIN
	RETURN CONCAT('MK ', iif(trim(SUBSTRING(@gear_name,4,2))like'%e%', 13, trim(SUBSTRING(@gear_name,4,2))))
END
GO