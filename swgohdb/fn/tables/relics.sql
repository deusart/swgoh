USE swgoh
GO

IF NOT EXISTS (
	SELECT * FROM sys.tables WHERE [name] = N'relics'
	AND schema_id = (SELECT schema_id FROM sys.schemas WHERE [name] = N'fn')
)
BEGIN	
	CREATE TABLE fn.relics (
		relic_number int NULL
		, relic_cost int NULL
		, fragmented_signal_data int NULL
		, incomplete_signal_data int NULL
		, flawed_signal_data int NULL
		, carbonite_circuit_board int NULL
		, bronzium_wiring int NULL
		, chromium_transistor int NULL
		, aurodium_heatsink int NULL
		, electrium_conductor int NULL
		, zinbiddle_card int NULL
		, impulse_detector int NULL
		, aeromagnifier int NULL
		, gyrda_keypad int NULL
		, droid_brain int NULL
	) ON [PRIMARY]
	ALTER TABLE fn.relics ADD DEFAULT (0) FOR fragmented_signal_data
	ALTER TABLE fn.relics ADD DEFAULT (0) FOR incomplete_signal_data
	ALTER TABLE fn.relics ADD DEFAULT (0) FOR flawed_signal_data
	ALTER TABLE fn.relics ADD DEFAULT (0) FOR carbonite_circuit_board
	ALTER TABLE fn.relics ADD DEFAULT (0) FOR bronzium_wiring
	ALTER TABLE fn.relics ADD DEFAULT (0) FOR chromium_transistor
	ALTER TABLE fn.relics ADD DEFAULT (0) FOR aurodium_heatsink
	ALTER TABLE fn.relics ADD DEFAULT (0) FOR electrium_conductor
	ALTER TABLE fn.relics ADD DEFAULT (0) FOR zinbiddle_card
	ALTER TABLE fn.relics ADD DEFAULT (0) FOR impulse_detector
	ALTER TABLE fn.relics ADD DEFAULT (0) FOR aeromagnifier
	ALTER TABLE fn.relics ADD DEFAULT (0) FOR gyrda_keypad
	ALTER TABLE fn.relics ADD DEFAULT (0) FOR droid_brain
END

