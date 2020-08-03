//Judicial visor: Grants the ability to smite an area and knocking down the unfaithful nearby every thirty seconds.
/obj/item/clothing/glasses/judicial_visor
	name = "judicial visor"
	desc = "A strange purple-lensed visor. Looking at it inspires an odd sense of guilt."
	icon = 'infinity/icons/obj/clothing/clockwork_garb.dmi'
	icon_state = "judicial_visor_0"
	item_state = "sunglasses"
	flash_protection = FLASH_PROTECTION_MAJOR

	action_button_name = "Use Judical Visor"

	var/online = FALSE //If the visor is online
	var/recharging = FALSE //If the visor is currently recharging
	var/recharge_cooldown = 30 SECONDS

/obj/item/clothing/glasses/judicial_visor/equipped(mob/living/user, slot)
	..()
	if(slot != slot_glasses)
		update_status(FALSE)
		return
	if(is_servant_of_ratvar(user))
		update_status(TRUE)
	else
		update_status(FALSE)
	if(iscultist(user)) //Cultists spontaneously combust
		to_chat(user, "<span class='heavy_brass'>\"Consider yourself judged, whelp.\"</span>")
		to_chat(user, "<span class='bigdanger'>You suddenly catch fire!</span>")
		user.adjust_fire_stacks(5)
		user.IgniteMob()
	return 1

/obj/item/clothing/glasses/judicial_visor/dropped(mob/user)
	. = ..()
	addtimer(CALLBACK(src, .proc/check_on_mob, user), 1)

/obj/item/clothing/glasses/judicial_visor/proc/check_on_mob(var/mob/living/carbon/human/user)
	if(user && src != user.glasses) //if we happen to check and we AREN'T in the slot, we need to remove our shit from whoever we got dropped from
		update_status(FALSE)

/obj/item/clothing/glasses/judicial_visor/proc/update_status(change_to)
	if(recharging || !isliving(loc))
		icon_state = "judicial_visor_0"
		return 0
	if(online == change_to)
		return 0
	var/mob/living/L = loc
	online = change_to
	icon_state = "judicial_visor_[online]"
	L.update_inv_glasses()
	if(!is_servant_of_ratvar(L) || L.stat)
		return 0
	switch(online)
		if(TRUE)
			to_chat(L, "<span class='notice'>As you put on [src], its lens begins to glow, information flashing before your eyes.</span>\n\
			<span class='heavy_brass'>Judicial visor active. Smite system online. Use the visor to judge all non-servants that can see you.</span>")

		if(FALSE)
			to_chat(L, "<span class='notice'>As you take off [src], its lens darkens once more.</span>")
	return 1

/obj/item/clothing/glasses/judicial_visor/proc/recharge_visor(var/mob/living/carbon/human/user)
	if(user && !is_servant_of_ratvar(user))
		return 0
	recharging = FALSE
	if(user && src == user.glasses && !user.stat)
		to_chat(user, "<span class='brass'>Your [name] hums. It is ready.</span>")
	else
		online = FALSE
	icon_state = "judicial_visor_[online]"
	if(user)
		user.update_inv_glasses()

/obj/item/clothing/glasses/judicial_visor/proc/acquire_nearby_targets()
	var/list/targets = list()
	for(var/mob/living/L in oviewers(7, null)) //Doesn't attack the blind
		if(is_servant_of_ratvar(L) || (L.blinded))
			continue
		if(L.stat || L.restrained() || L.buckled || L.lying)
			continue
		if(istype(L, /mob/living/simple_animal/hostile))
			var/mob/living/simple_animal/hostile/H = L
			if(("ratvar" in H.faction) || (!H.mind && "neutral" in H.faction))
				continue
		else if(!L.mind)
			continue
		targets += L
	return targets

/obj/item/clothing/glasses/judicial_visor/attack_self(mob/user)
	if(user.incapacitated())
		return

	if(!online)
		return

	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		if(!is_servant_of_ratvar(H))
			return

		if(H.glasses != src)
			return

		var/targets = acquire_nearby_targets()

		for(var/mob/living/target in targets)
			to_chat(target, SPAN_WARNING("You can see [user]'s [src] starting to heat up! Better hide!")) //Here's the thing. Only propper targets can see this

		if(!do_after(user, 3 SECONDS))
			return

		judge(user)

/obj/item/clothing/glasses/judicial_visor/proc/judge(var/mob/living/user) //Welp, prepare to die? Joking, but still, this thing is powerful

	var/list/targets = acquire_nearby_targets()

	playsound(loc, 'sound/magic/magic_missile.ogg', 50, 1, 1, 1)

	var/obj/effect/temporary/blast = new /obj/effect/temporary(get_turf(src), 14, 'infinity/icons/effects/96x96.dmi', "judicial_explosion")
	blast.pixel_x = -32
	blast.pixel_y = -32

	for(var/mob/living/L in targets)
		L.Weaken(10)
		L.Stun(3)
		L.adjustBruteLoss(20)
		if(!iscultist(L))
			L.visible_message("<span class='warning'>[L] is struck by a judicial explosion!</span>", \
			"<span class='userdanger'>[!issilicon(L) ? "An unseen force slams you into the ground!" : "ERROR: Motor servos disabled by external source!"]</span>")
		else
			L.visible_message("<span class='warning'>[L] is struck by a judicial explosion!</span>", \
			"<span class='heavy_brass'>\"Keep an eye out, filth.\"</span>\n<span class='bigdanger'>A burst of heat crushes you against the ground!</span>")
			L.adjust_fire_stacks(2) //sets cultist targets on fire
			L.IgniteMob()
			L.adjustFireLoss(5)
	playsound(src, 'infinity/sound/effects/explosion_distant.ogg', 100, 1, 1, 1)
	to_chat(user, "<span class='brass'><b>[targets.len ? "Successfully judged <span class='neovgre'>[targets.len]</span>":"Judged no"] heretic[targets.len == 1 ? "":"s"].</b></span>")

	recharging = TRUE
	icon_state = "judicial_visor_0"
	update_icon()
	addtimer(CALLBACK(src, .proc/recharge_visor, user), recharge_cooldown)