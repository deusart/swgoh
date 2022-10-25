USE swgoh
GO

-- status_legends
IF NOT EXISTS (
	SELECT * FROM sys.tables WHERE [name] = N'status_legends'
	AND schema_id = (SELECT schema_id FROM sys.schemas WHERE [name] = N'history')
)
BEGIN
	CREATE TABLE history.status_legends (
		row_id int IDENTITY(1,1) NOT NULL
		, member_allycode bigint NULL
		, legend_id nvarchar(max) NULL
		, completion decimal(5,4) NULL
		, created_at datetime NOT NULL
	) ON [PRIMARY]
    ALTER TABLE history.status_legends ADD CONSTRAINT df_history_status_legends_created_at DEFAULT (GETUTCDATE()) FOR created_at
END
GO