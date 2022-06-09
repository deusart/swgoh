USE swgoh
GO

-- goals
IF NOT EXISTS (
	SELECT * FROM sys.tables WHERE [name] = N'goals'
	AND schema_id = (SELECT schema_id FROM sys.schemas WHERE [name] = N'input')
)
BEGIN
	CREATE TABLE input.goals (
		row_id int IDENTITY(1,1) NOT NULL
		, unit_id nvarchar(50) NULL
		, unit_type nvarchar(50) NULL
		, priority_num int
		, goal_name nvarchar(50) NULL
		, goal_status nvarchar(50) NULL
		, unit_stars int
		, unit_level int
		, unit_relic int
		, unit_gear int
		, updated_at datetime NOT NULL
		, CONSTRAINT [PK_goals_input] 
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
	ALTER TABLE input.goals ADD DEFAULT (7) FOR unit_stars
	ALTER TABLE input.goals ADD DEFAULT ('Basic') FOR goal_name
	ALTER TABLE input.goals ADD DEFAULT ('Process') FOR goal_status
	ALTER TABLE input.goals ADD DEFAULT ('character') FOR unit_type
	ALTER TABLE input.goals ADD DEFAULT (80) FOR unit_level
	ALTER TABLE input.goals ADD DEFAULT (0) FOR unit_relic
	ALTER TABLE input.goals ADD DEFAULT (6) FOR unit_gear
	ALTER TABLE input.goals ADD DEFAULT (0) FOR priority_num
	ALTER TABLE input.goals ADD DEFAULT (GETUTCDATE()) FOR updated_at
END
GO