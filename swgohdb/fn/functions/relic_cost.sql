USE swgoh
GO

CREATE OR ALTER FUNCTION fn.relic_cost(@max_relic int)
RETURNS TABLE 
AS
RETURN 
(
	SELECT 
		c.character_id
		, isnull(character_relic, 0) as character_relic
		, sum(relic_cost) as relic_credit_cost
		, sum(fragmented_signal_data) as fragmented_signal_data
		, sum(incomplete_signal_data) as incomplete_signal_data
		, sum(flawed_signal_data) as flawed_signal_data
		, sum(carbonite_circuit_board) as carbonite_circuit_board
		, sum(bronzium_wiring) as bronzium_wiring
		, sum(chromium_transistor) as chromium_transistor
		, sum(aurodium_heatsink) as aurodium_heatsink
		, sum(electrium_conductor) as electrium_conductor
		, sum(zinbiddle_card) as zinbiddle_card
		, sum(impulse_detector) as impulse_detector
		, sum(aeromagnifier) as aeromagnifier
		, sum(gyrda_keypad) as gyrda_keypad
		, sum(droid_brain) as droid_brain
	FROM fn.relics r
	CROSS JOIN stage.characters c
	LEFT JOIN player.characters pc ON c.character_id = pc.character_id
	WHERE isnull(character_relic, 0) < r.relic_number AND r.relic_number <= @max_relic
	GROUP BY c.character_id, isnull(character_relic, 0)
)
GO
