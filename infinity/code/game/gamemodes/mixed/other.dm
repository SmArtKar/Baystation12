/datum/game_mode/intrigue
	name = "Traitor & Ninja"
	round_description = "Traitors and a ninja are about to end your carrier."
	extended_round_description = "Traitors and a ninja are about to end your carrier."
	config_tag = "intrigue"
	required_players = 9
	required_enemies = 4
	end_on_antag_death = FALSE
	antag_tags = list(MODE_TRAITOR, MODE_NINJA)
	require_all_templates = TRUE

/datum/game_mode/lizard
	name = "Changeling & Wizard"
	round_description = "Changeling and a wizard are about to end your carrier."
	extended_round_description = "Changeling and a wizard are about to end your carrier."
	config_tag = "lizard"
	required_players = 9
	required_enemies = 3
	end_on_antag_death = FALSE
	antag_tags = list(MODE_CHANGELING, MODE_WIZARD)
	require_all_templates = TRUE

/datum/game_mode/jackpot
	name = "Traitor & Ninja & Changeling & Wizard"
	round_description = "The ship is full of antagonists. Crew, the new objective - survive."
	extended_round_description = "Jackpot! You got all your friends today - traitors, changelings, ninja and wisard."
	config_tag = "jackpot"
	required_players = 14
	required_enemies = 6
	end_on_antag_death = FALSE
	antag_tags = list(MODE_TRAITOR, MODE_CHANGELING, MODE_NINJA, MODE_WIZARD)
	require_all_templates = TRUE

/datum/game_mode/pizda
	name = "Pizda"
	round_description = "The ship is full of antagonists. Crew, the new objective - survive."
	extended_round_description = "Jackpot! You got all your friends today - traitors, changelings, ninja and wisard."
	config_tag = "pizda"
	required_players = 0
	required_enemies = 1
	end_on_antag_death = FALSE
	antag_tags = list(MODE_ABDUCTOR)
	require_all_templates = TRUE