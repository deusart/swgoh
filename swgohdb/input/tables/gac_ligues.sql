USE swgoh
GO

-- gac_ligues
IF NOT EXISTS (
	SELECT * FROM sys.tables WHERE [name] = N'gac_ligues'
	AND schema_id = (SELECT schema_id FROM sys.schemas WHERE [name] = N'input')
)
BEGIN
	CREATE TABLE input.gac_ligues (
		row_id int IDENTITY(1,1) NOT NULL
		, gac_date date NULL
		, gac_ligue nvarchar(max) NULL
		, players int		
		, updated_at datetime NOT NULL
		, CONSTRAINT [PK_gac_ligues_input] 
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
	ALTER TABLE input.gac_ligues ADD DEFAULT (GETUTCDATE()) FOR updated_at
END
GO