USE swgoh
GO

-- members_characters_skills
IF NOT EXISTS (
	SELECT * FROM sys.tables WHERE [name] = N'members_characters_skills'
	AND schema_id = (SELECT schema_id FROM sys.schemas WHERE [name] = N'stage')
)
BEGIN
	CREATE TABLE stage.members_characters_skills (		
		row_id int IDENTITY(1,1) NOT NULL		
		, member_allycode bigint NULL
		, character_id nvarchar(250) NULL
		, skill_id nvarchar(250) NULL
		, tier int NULL
		, tier_max int NULL
		, is_zeta bit NULL
		, updated bigint NULL
		, hash_diff binary(16) NOT NULL
		, created_at datetime NOT NULL
		, updated_at datetime NOT NULL
	) ON [PRIMARY]
    ALTER TABLE stage.members_characters_skills ADD CONSTRAINT df_stage_members_characters_skills_created_at DEFAULT (GETUTCDATE()) FOR created_at
    ALTER TABLE stage.members_characters_skills ADD CONSTRAINT df_stage_members_characters_skills_updated_at DEFAULT (GETUTCDATE()) FOR updated_at
END
GO