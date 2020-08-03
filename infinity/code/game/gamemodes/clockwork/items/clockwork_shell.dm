//Construct shells that can be activated by ghosts.
/obj/item/weapon/clockwork/construct_chassis
	name = "construct chassis"
	desc = "A shell formed out of brass, presumably for housing machinery."
	clockwork_desc = "A construct chassis. It can be activated at any time by a willing ghost."
	var/construct_name = "basic construct"
	var/construct_desc = "<span class='alloy'>There is no construct for this chassis. Report this to a coder.</span>"
	icon_state = "anime_fragment"
	w_class = ITEM_SIZE_HUGE
	var/creation_message = "<span class='brass'>The chassis shudders and hums to life!</span>"
	var/construct_type

/obj/item/weapon/clockwork/construct_chassis/Initialize()
	. = ..()
	var/area/A = get_area(src)
	if(A && construct_type)
		for(var/mob/observer/ghost/C in GLOB.player_list)
			to_chat(C, "A [construct_name] chassis has been created in [A.name]! <a href='byond://?src=\ref[src];create=1'>Become a construct!</a>")
			C.playsound_local('infinity/sound/magic/clockwork/fellowship_armory.ogg', repeat = 0, wait = 0, volume = 20, channel = GLOB.vote_sound_channel)

/obj/item/weapon/clockwork/construct_chassis/Topic(href, href_list)
	var/mob/user = usr
	if(href_list["create"])
		attack_ghost(user)

/obj/item/weapon/clockwork/construct_chassis/examine(mob/user)
	clockwork_desc = "[clockwork_desc]<br>[construct_desc]"
	..()
	clockwork_desc = initial(clockwork_desc)

/obj/item/weapon/clockwork/construct_chassis/attack_hand(mob/living/user)
	if(w_class >= ITEM_SIZE_HUGE)
		to_chat(user, "<span class='warning'>[src] is too cumbersome to carry! Drag it around instead!</span>")
		return
	. = ..()

/obj/item/weapon/clockwork/construct_chassis/attack_ghost(mob/user)
	if(!SSticker.mode)
		to_chat(user, "<span class='danger'>You cannot use that before the game has started.</span>")
		return
	if(QDELETED(src))
		to_chat(user, "<span class='danger'>You were too late! Better luck next time.</span>")
		return
	user.forceMove(get_turf(src)) //If we attack through the alert, jump to the chassis so we know what we're getting into
	if(alert(user, "Become a [construct_name]?", construct_name, "Yes", "Cancel") == "Cancel")
		return
	if(QDELETED(src))
		to_chat(user, "<span class='danger'>You were too late! Better luck next time.</span>")
		return
	visible_message(creation_message)
	var/mob/living/construct = new construct_type(get_turf(src))
	construct.key = user.key
	qdel(user)
	qdel(src)
