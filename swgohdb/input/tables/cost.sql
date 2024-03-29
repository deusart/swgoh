USE swgoh
GO

-- cost
IF NOT EXISTS (
	SELECT * FROM sys.tables WHERE [name] = N'cost'
	AND schema_id = (SELECT schema_id FROM sys.schemas WHERE [name] = N'input')
)
BEGIN
	CREATE TABLE input.cost (
		row_id int IDENTITY(1,1) NOT NULL
		, gear_part_name nvarchar(max) NULL
		, crystal float
		, gac float
		, gt float
		, get1 float
		, get2 float	
		, mk1 float
		, mk2 float
		, mk3 float		
		, updated_at datetime NOT NULL
		, CONSTRAINT [PK_cost_input] 
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
	ALTER TABLE input.cost ADD DEFAULT (GETUTCDATE()) FOR updated_at
END
GO