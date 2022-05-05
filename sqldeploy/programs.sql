USE hordeby
GO

CREATE OR ALTER FUNCTION fn.hash_diff (@str nvarchar(max))
RETURNS binary(16)
AS
BEGIN
	RETURN (SELECT HASHBYTES('MD5', @str))
END
GO