USE swgoh
GO

-- members_characters_skills
IF NOT EXISTS (
	SELECT * FROM sys.tables WHERE [name] = N'members_characters_skills'
	AND schema_id = (SELECT schema_id FROM sys.schemas WHERE [name] = N'history')
)
BEGIN
	CREATE TABLE history.members_characters_skills (		
		row_id int IDENTITY(1,1) NOT NULL		
		, member_allycode bigint NULL
		, character_id nvarchar(max) NULL
		, skill_id nvarchar(max) NULL
		, tier int NULL
		, tier_max int NULL
		, is_zeta bit NULL
		, updated bigint NULL
		, created_at datetime NOT NULL
		, updated_at datetime NOT NULL
	) ON [PRIMARY]
    ALTER TABLE history.members_characters_skills ADD CONSTRAINT df_history_members_characters_skills_created_at DEFAULT (GETUTCDATE()) FOR created_at
    ALTER TABLE history.members_characters_skills ADD CONSTRAINT df_history_members_characters_skills_updated_at DEFAULT (GETUTCDATE()) FOR updated_at
END
GO

CREATE OR ALTER TRIGGER stage.members_characters_skills_update
   ON stage.members_characters_skills
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
	INSERT INTO history.members_characters_skills(
		 member_allycode, character_id
		, skill_id, tier, tier_max
		, is_zeta, updated
		)
	SELECT member_allycode, character_id
		, skill_id, tier, tier_max
		, is_zeta, updated
	FROM inserted
END