USE swgoh
GO

-- skills
IF NOT EXISTS (
	SELECT * FROM sys.tables WHERE [name] = N'skills'
	AND schema_id = (SELECT schema_id FROM sys.schemas WHERE [name] = N'stage')
)
BEGIN
	CREATE TABLE stage.skills (
		row_id int IDENTITY(1,1) NOT NULL
		, skill_id nvarchar(250) NULL
		, character_id nvarchar(250) NULL
		, skill_name nvarchar(250) NULL
		, tier_max int NULL
		, is_zeta bit NULL
		, is_omega bit NULL
		, is_omicron bit NULL
		, omicron_mode int NULL
		, hash_diff binary(16)
		, created_at datetime NOT NULL
		, updated_at datetime NOT NULL
	) ON [PRIMARY]
    ALTER TABLE stage.skills ADD CONSTRAINT df_stage_skills_created_at DEFAULT (GETUTCDATE()) FOR created_at
    ALTER TABLE stage.skills ADD CONSTRAINT df_stage_skills_updated_at DEFAULT (GETUTCDATE()) FOR updated_at
END
GO
