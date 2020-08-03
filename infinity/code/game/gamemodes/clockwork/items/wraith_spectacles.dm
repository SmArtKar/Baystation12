/obj/item/clothing/glasses/wraith_spectacles
	name = "antique spectacles"
	desc = "Unnerving glasses with opaque yellow lenses."
	icon = 'infinity/icons/obj/clothing/clockwork_garb.dmi'
	icon_state = "wraith_specsup"
	item_state = "glasses"
	action_button_name = "Toggle Spectacles"


	var/up = TRUE

/obj/item/clothing/glasses/wraith_spectacles/attack_self(mob/user)
	if(user.incapacitated())
		return

	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		up = !up
		if(up)
			icon_state = "wraith_specsup"
		else
			icon_state = "wraith_specs"

		if(src == H.glasses && !up)
			if(H.blinded)
				to_chat(H, "<span class='heavy_brass'>\"You're blind, idiot. Stop embarrassing yourself.\"</span>")
				return
			if(blind_cultist(H))
				return
			if(is_servant_of_ratvar(H))
				to_chat(H, "<span class='heavy_brass'>You push the spectacles down, and all is revealed to you. Your eyes begin to itch - you cannot do this for long.</span>")
				deal_and_heal(user)
			else
				to_chat(H, "<span class='heavy_brass'>You push the spectacles down, but you can't see through the glass.</span>")

		set_vision_vars(H)

/obj/item/clothing/glasses/wraith_spectacles/equipped(mob/living/user, slot)
	..()
	if(!ishuman(loc))
		return
	var/mob/living/carbon/human/H = loc
	if(slot != slot_glasses || up)
		return
	if(H.blinded)
		to_chat(H, "<span class='heavy_brass'>\"You're blind, idiot. Stop embarrassing yourself.\"</span>")
		return
	if(blind_cultist(H))
		return
	if(is_servant_of_ratvar(H))
		to_chat(H, "<span class='heavy_brass'>You push the spectacles down, and all is revealed to you. Your eyes begin to itch - you cannot do this for long.</span>")
		deal_and_heal(user)
	else
		to_chat(H, "<span class='heavy_brass'>You push the spectacles down, but you can't see through the glass.</span>")

	set_vision_vars()


/obj/item/clothing/glasses/wraith_spectacles/proc/blind_cultist(mob/living/victim)
	if(iscultist(victim))
		to_chat(victim, "<span class='heavy_brass'>\"It looks like Nar-Sie's dogs really don't value their eyes.\"</span>")
		to_chat(victim, "<span class='bigdanger'>Your eyes explode with horrific pain!</span>")
		victim.emote("scream")
		victim.blinded = TRUE
		return TRUE

/obj/item/clothing/glasses/wraith_spectacles/proc/set_vision_vars(var/mob/living/carbon/human/H)
	tint = 0
	vision_flags = null
	darkness_view = 2
	if(!up)
		if(is_servant_of_ratvar(loc))
			vision_flags = SEE_MOBS | SEE_TURFS | SEE_OBJS
			darkness_view = 3
		else
			tint = 3

	H.update_equipment_vision()

/obj/item/clothing/glasses/wraith_spectacles/proc/deal_and_heal(var/mob/living/user)
	if(!ishuman(user))
		return

	var/mob/living/carbon/human/H = user

	var/eye_damage_done = 0

	while(loc == user && !up)
		eye_damage_done = min(35, adjust_eye_damage(H, eye_damage_done))
		sleep(5)

	var/eye_damage_healed = 0

	while(loc != user || up)
		eye_damage_healed = adjust_eye_heal(H, eye_damage_done, eye_damage_healed)
		sleep(5)
		if(eye_damage_healed == -1)
			return


/obj/item/clothing/glasses/wraith_spectacles/proc/adjust_eye_damage(var/mob/living/carbon/human/H, var/eye_damage_done)
	if(H.blinded)
		return eye_damage_done
	var/obj/item/organ/internal/eyes/eyes = H.internal_organs_by_name[BP_EYES]

	eyes.damage += 0.1
	eye_damage_done += 0.1

	if(eyes.damage >= 20)
		H.eye_blurry = 2

	if(eye_damage_done >= eyes.min_broken_damage - 5 && !H.disabilities & NEARSIGHTED)
		to_chat(H, "<span class='nzcrentr'>Your vision doubles, then trembles. Darkness begins to close in. You can't keep this up!</span>")
		H.disabilities |= NEARSIGHTED

	if(eye_damage_done >= eyes.min_broken_damage && !H.blinded)
		to_chat(H, "<span class='nzcrentr_large'>A piercing white light floods your vision. Suddenly, all goes dark!</span>")
		H.blinded = 1

	if(prob(min(1, eye_damage_done)))
		to_chat(H, "<span class='nzcrentr_small'><i>Your eyes continue to burn.</i></span>")

	return eye_damage_done

/obj/item/clothing/glasses/wraith_spectacles/proc/adjust_eye_heal(var/mob/living/carbon/human/H, var/eye_damage_done, var/eye_damage_healed)

	var/obj/item/organ/internal/eyes/eyes = H.internal_organs_by_name[BP_EYES]

	if (eyes.damage == 0)
		return -1
	if(eye_damage_healed > eye_damage_done)
		return -1


	eyes.damage -= 0.1
	eye_damage_healed += 0.1

	if(eye_damage_done >= eyes.min_broken_damage - 5 && H.disabilities & NEARSIGHTED)
		to_chat(H, "<span class='nzcrentr'>You feel your eyes almost fully repair from the effect of [src].</span>")
		H.disabilities &= ~NEARSIGHTED

	if(eye_damage_done >= eyes.min_broken_damage && H.blinded)
		to_chat(H, "<span class='nzcrentr_large'>Your vision returns back to you.</span>")
		H.blinded = 0

	if(prob(1))
		to_chat(H, "<span class='nzcrentr_small'><i>You feel soothing sensation in your eyes.</i></span>")

	return eye_damage_healed
