USE swgoh
GO

-- custom
IF NOT EXISTS (
	SELECT * FROM sys.tables WHERE [name] = N'customs'
	AND schema_id = (SELECT schema_id FROM sys.schemas WHERE [name] = N'stage')
)
BEGIN
	CREATE TABLE stage.customs (		
		row_id int IDENTITY(1,1) NOT NULL
		, custom_id nvarchar(250) NULL
		, custom_value_char nvarchar(250) NULL
		, custom_value_int INT NULL
	) ON [PRIMARY]
	
	INSERT INTO stage.customs (custom_id, custom_value_char)
	VALUES ('opponets_name', '')
END
GO