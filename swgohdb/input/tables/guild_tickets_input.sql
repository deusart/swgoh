USE swgoh
GO

-- guild_tickets_input
IF NOT EXISTS (
	SELECT * FROM sys.tables WHERE [name] = N'guild_tickets_input'
	AND schema_id = (SELECT schema_id FROM sys.schemas WHERE [name] = N'input')
)
BEGIN
	CREATE TABLE input.guild_tickets_input (
		row_id int IDENTITY(1,1) NOT NULL
		, user_nickname nvarchar(250) NULL
		, tickets int NULL
		, updated_at datetime NOT NULL
		, CONSTRAINT [PK_guild_tickets_input] 
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
	ALTER TABLE input.guild_tickets_input ADD DEFAULT (getutcdate()) FOR updated_at
END
GO