USE swgoh
GO

-- results_tb
IF NOT EXISTS (
	SELECT * FROM sys.tables WHERE [name] = N'results_tb'
	AND schema_id = (SELECT schema_id FROM sys.schemas WHERE [name] = N'input')
)
BEGIN
	CREATE TABLE input.results_tb (
		row_id int IDENTITY(1,1) NOT NULL
		, tb_id nvarchar(250) NULL
		, stars int NULL
		, unit_shards int NULL
		, date_start datetime NULL
	) ON [PRIMARY]
END
GO