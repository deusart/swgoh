USE swgoh
GO

-- journey_requirements
IF NOT EXISTS (
	SELECT * FROM sys.tables WHERE [name] = N'journey_requirements'
	AND schema_id = (SELECT schema_id FROM sys.schemas WHERE [name] = N'input')
)
BEGIN
	CREATE TABLE input.journey_requirements (
		row_id int IDENTITY(1,1) NOT NULL
		, journey_id nvarchar(250) NULL
		, journey_level int NULL
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
	ALTER TABLE input.journey_requirements ADD DEFAULT ('unit') FOR unit_type
	ALTER TABLE input.journey_requirements ADD DEFAULT (0) FOR is_option
	ALTER TABLE input.journey_requirements ADD  DEFAULT (7) FOR req_stars
	ALTER TABLE input.journey_requirements ADD  DEFAULT (0) FOR req_relic
	ALTER TABLE input.journey_requirements ADD  DEFAULT (5000) FOR req_power
	ALTER TABLE input.journey_requirements ADD  DEFAULT (5) FOR units_total
	ALTER TABLE input.journey_requirements ADD  DEFAULT (1) FOR unit_rarity
END
GO