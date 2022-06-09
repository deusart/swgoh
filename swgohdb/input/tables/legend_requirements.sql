USE swgoh
GO

-- legend_requirements
IF NOT EXISTS (
	SELECT * FROM sys.tables WHERE [name] = N'legend_requirements'
	AND schema_id = (SELECT schema_id FROM sys.schemas WHERE [name] = N'input')
)
BEGIN
	CREATE TABLE input.legend_requirements (
		row_id int IDENTITY(1,1) NOT NULL
		, legend_id nvarchar(250) NULL
		, unit_id nvarchar(250) NULL
		, unit_type nvarchar(50) NULL
		, req_stars int NULL
		, req_relic int NULL
		, req_power int NULL
		, unit_rarity int NULL
	) ON [PRIMARY]
END
GO