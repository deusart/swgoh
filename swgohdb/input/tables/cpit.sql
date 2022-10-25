USE swgoh
GO

-- cpit
IF NOT EXISTS (
	SELECT * FROM sys.tables WHERE [name] = N'cpit'
	AND schema_id = (SELECT schema_id FROM sys.schemas WHERE [name] = N'input')
)
BEGIN
	CREATE TABLE input.cpit (
		row_id int IDENTITY(1,1) NOT NULL
		, team nvarchar(50) NULL
		, character_id nvarchar(50) NULL
		, priority_num int NULL
		, phase_num int NULL
		, damage decimal(3,2) NULL
		, updated_at datetime NOT NULL
		, CONSTRAINT [PK_cpit_input] 
			PRIMARY KEY CLUSTERED (
				row_id ASC
			) 
			WITH (
				PAD_INDEX = OFF
				, STATISTICS_NORECOMPUTE = OFF
				, IGNORE_DUP_KEY = OFF
				, ALLOW_ROW_LOCKS = ON
				, ALLOW_PAGE_LOCKS = ON
				, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF
			) ON [PRIMARY]
	) ON [PRIMARY]
	ALTER TABLE input.cpit ADD DEFAULT (0) FOR phase_num
	ALTER TABLE input.cpit ADD DEFAULT (0) FOR priority_num
	ALTER TABLE input.cpit ADD DEFAULT (GETUTCDATE()) FOR updated_at
END
GO