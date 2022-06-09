USE swgoh
GO

IF NOT EXISTS (
	SELECT * FROM sys.tables WHERE [name] = N'stars'
	AND schema_id = (SELECT schema_id FROM sys.schemas WHERE [name] = N'fn')
)
BEGIN	
	CREATE TABLE fn.stars (
		star_number int NULL
		, star_cost int NULL
		, star_shards int NULL
	) ON [PRIMARY]
END