USE swgoh
GO

-- gear_inventory
IF NOT EXISTS (
	SELECT * FROM sys.tables WHERE [name] = N'gear_inventory'
	AND schema_id = (SELECT schema_id FROM sys.schemas WHERE [name] = N'input')
)
BEGIN
	CREATE TABLE input.gear_inventory(
		row_id int IDENTITY(1,1) NOT NULL
		, gear_base_id nvarchar(250) NULL
		, gear_part_name nvarchar(250) NULL
		, amount_onhands int NULL
		, updated_at datetime NULL
		, week_income int NULL
		, CONSTRAINT [PK_gear_inventory]
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
	ALTER TABLE input.gear_inventory ADD  CONSTRAINT DF_gear_inventory_upadted_at  DEFAULT (getdate()) FOR updated_at
END
GO