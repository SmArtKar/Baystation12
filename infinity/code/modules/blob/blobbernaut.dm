/mob/living/simple_animal/hostile/blobbernaut
	name = "blobbernaut"
	desc = "A giant, dangerous creature, made out of blob."
	layer = BLOB_CORE_LAYER + 0.2
	icon = 'infinity/icons/mob/blob.dmi'
	speak_emote = list("gibbers")
	icon_state = "blobbernaut"
	icon_living = "blobbernaut"
	icon_dead = "blobbernaut_dead"
	health = 100
	maxHealth = 100
	melee_damage_lower = 15
	melee_damage_upper = 25
	attacktext = "smashed"
	attack_sound = 'sound/effects/attackblob.ogg'
	faction = "blob"
	speed = 2

	var/obj/effect/biomass/core/core

/mob/living/simple_animal/hostile/blobbernaut/Initialize()
	. = ..()
	flick("blobbernaut_produce",src)

/mob/living/simple_animal/hostile/blobbernaut/Life()
	. = ..()
	if(locate(/obj/effect/biomass) in get_turf(src))
		health = min(maxHealth, health + 1)
	if(core)
		color = core.strain.blob_color

/mob/living/simple_animal/hostile/blobbernaut/death()
	flick("blobbernaut_death",src)
	. = ..()

/mob/living/simple_animal/hostile/blobbernaut/attack_ghost(var/mob/observer/ghost/user)
	if(core)
		return

	var/confirm = alert(user, "Are you sure you want to join as a Blobbernaut?", "Become Blobbernaut", "Yes", "No")

	if(!src || confirm != "Yes")
		return

	if(!user || !user.ckey)
		return

	ckey = user.ckey
	qdel(user)