USE swgoh
GO

-- results_tb
IF NOT EXISTS (
	SELECT * FROM sys.tables WHERE [name] = N'results_krayt'
	AND schema_id = (SELECT schema_id FROM sys.schemas WHERE [name] = N'input')
)
BEGIN
	CREATE TABLE input.results_krayt (
		row_id int IDENTITY(1,1) NOT NULL
		, member_allycode bigint NULL
		, member_name nvarchar(250) NULL
		, score_first int NULL
		, score_01 int NULL
		, score_02 int NULL
		, score_03 int NULL
		, score_max int NULL
	) ON [PRIMARY]
END
GO