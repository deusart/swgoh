USE swgoh
GO

-- tb_squads
IF NOT EXISTS (
	SELECT * FROM sys.tables WHERE [name] = N'tb_squads'
	AND schema_id = (SELECT schema_id FROM sys.schemas WHERE [name] = N'input')
)
BEGIN
	CREATE TABLE input.tb_squads (
		row_id int IDENTITY(1,1) NOT NULL
		, tb_id nvarchar(250) NULL
		, mission_id nvarchar(250) NULL
		, battle_step int NULL
		, unit_id nvarchar(250) NULL
		, unit_tag nvarchar(250) NULL
		, unit_type nvarchar(50) NULL
		, is_option int NULL
		, req_stars int NULL
		, req_relic int NULL
		, req_power int NULL
		, units_total int NULL
		, unit_rarity int NULL
	) ON [PRIMARY]
	ALTER TABLE input.tb_squads ADD DEFAULT ('unit') FOR unit_type
	ALTER TABLE input.tb_squads ADD DEFAULT (0) FOR is_option
	ALTER TABLE input.tb_squads ADD  DEFAULT (7) FOR req_stars
	ALTER TABLE input.tb_squads ADD  DEFAULT (0) FOR req_relic
	ALTER TABLE input.tb_squads ADD  DEFAULT (5000) FOR req_power
	ALTER TABLE input.tb_squads ADD  DEFAULT (5) FOR units_total
	ALTER TABLE input.tb_squads ADD  DEFAULT (1) FOR unit_rarity
END
GO