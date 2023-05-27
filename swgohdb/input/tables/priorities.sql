USE swgoh
GO

-- priorities
IF NOT EXISTS (
	SELECT * FROM sys.tables WHERE [name] = N'priorities'
	AND schema_id = (SELECT schema_id FROM sys.schemas WHERE [name] = N'input')
)
BEGIN
	CREATE TABLE input.priorities (
		row_id int IDENTITY(1,1) NOT NULL
		, priority_num nvarchar(50) NULL
		, priority_name nvarchar(50) NULL		
		, updated_at datetime NOT NULL
		, CONSTRAINT [PK_priorities_input] 
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
	ALTER TABLE input.priorities ADD DEFAULT (GETUTCDATE()) FOR updated_at
END
GO