/obj/item/clothing/head/helmet/clockwork
	name = "clockwork helmet"
	desc = "A heavy helmet made of brass."
	icon = 'infinity/icons/obj/clothing/clockwork_garb.dmi'
	icon_state = "clockwork_helmet"
	w_class = ITEM_SIZE_NORMAL
	flags_inv = HIDEEARS|BLOCKHAIR|HIDEFACE
	armor = list(melee = ARMOR_MELEE_MAJOR,
				 bullet = ARMOR_BALLISTIC_RESISTANT,
				 laser = ARMOR_LASER_MINOR,
				 energy = ARMOR_ENERGY_RESISTANT,
				 bomb = ARMOR_BIO_STRONG,
				 bio = ARMOR_BIO_SMALL,
				 rad = ARMOR_RAD_SMALL
				 )

/obj/item/clothing/head/helmet/clockwork/equipped(mob/living/user, slot)
	..()
	if(slot == slot_head && !is_servant_of_ratvar(user))
		if(!iscultist(user))
			to_chat(user, "<span class='heavy_brass'>\"Now now, this is for my servants, not you.\"</span>")
			user.visible_message("<span class='warning'>As [user] puts [src] on, it flickers off their head!</span>", "<span class='warning'>The helmet flickers off your head, leaving only nausea!</span>")
			if(ishuman(user))
				var/mob/living/carbon/human/H = user
				H.vomit(20)
		else
			to_chat(user, "<span class='heavy_brass'>\"Do you have a hole in your head? You're about to.\"</span>")
			to_chat(user, "<span class='bigdanger'>The helmet tries to drive a spike through your head as you scramble to remove it!</span>")
			user.emote("scream")
			user.apply_damage(30, BRUTE, BP_HEAD)
			user.adjustBrainLoss(30)
		addtimer(CALLBACK(user, /mob.proc/unEquip, src), 1) //equipped happens before putting stuff on(but not before picking items up), 1). thus, we need to wait for it to be on before forcing it off.

/obj/item/clothing/suit/armor/clockwork
	name = "clockwork cuirass"
	desc = "A bulky cuirass made of brass."
	icon = 'infinity/icons/obj/clothing/clockwork_garb.dmi'
	icon_state = "clockwork_cuirass"
	w_class = ITEM_SIZE_HUGE
	armor = list(melee = ARMOR_MELEE_MAJOR,
				 bullet = ARMOR_BALLISTIC_RESISTANT,
				 laser = ARMOR_LASER_MINOR,
				 energy = ARMOR_ENERGY_RESISTANT,
				 bomb = ARMOR_BIO_STRONG,
				 bio = ARMOR_BIO_SMALL,
				 rad = ARMOR_RAD_SMALL
				 )
	allowed = list(/obj/item/clothing/glasses/wraith_spectacles, /obj/item/clothing/glasses/judicial_visor, /obj/item/organ/internal/posibrain/soul_vessel)

/obj/item/clothing/suit/armor/clockwork/equipped(mob/living/user, slot)
	..()
	if(slot == slot_wear_suit && !is_servant_of_ratvar(user))
		if(!iscultist(user))
			to_chat(user, "<span class='heavy_brass'>\"Now now, this is for my servants, not you.\"</span>")
			user.visible_message("<span class='warning'>As [user] puts [src] on, it flickers off their body!</span>", "<span class='warning'>The curiass flickers off your body, leaving only nausea!</span>")
			if(ishuman(user))
				var/mob/living/carbon/human/H = user
				H.vomit(20)
		else
			to_chat(user, "<span class='heavy_brass'>\"I think this armor is too hot for you to handle.\"</span>")
			to_chat(user, "<span class='bigdanger'>The curiass emits a burst of flame as you scramble to get it off!</span>")
			user.emote("scream")
			user.apply_damage(15, BURN, "chest")
			user.adjust_fire_stacks(2)
			user.IgniteMob()
		addtimer(CALLBACK(user, /mob.proc/unEquip, src), 1)

/obj/item/clothing/gloves/clockwork
	name = "clockwork gauntlets"
	desc = "Heavy, shock-resistant gauntlets with brass reinforcement."
	icon = 'infinity/icons/obj/clothing/clockwork_garb.dmi'
	icon_state = "clockwork_gauntlets"
	item_state = "clockwork_gauntlets"
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	armor = list(melee = ARMOR_MELEE_MAJOR,
				 bullet = ARMOR_BALLISTIC_RESISTANT,
				 laser = ARMOR_LASER_MINOR,
				 energy = ARMOR_ENERGY_RESISTANT,
				 bomb = ARMOR_BIO_STRONG,
				 bio = ARMOR_BIO_SMALL,
				 rad = ARMOR_RAD_SMALL
				 )
/obj/item/clothing/gloves/clockwork/equipped(mob/living/user, slot)
	..()
	if(slot == slot_gloves && !is_servant_of_ratvar(user))
		if(!iscultist(user))
			to_chat(user, "<span class='heavy_brass'>\"Now now, this is for my servants, not you.\"</span>")
			user.visible_message("<span class='warning'>As [user] puts [src] on, it flickers off their arms!</span>", "<span class='warning'>The gauntlets flicker off your arms, leaving only nausea!</span>")
			if(ishuman(user))
				var/mob/living/carbon/human/H = user
				H.vomit()
		else
			to_chat(user, "<span class='heavy_brass'>\"Did you like having arms?\"</span>")
			to_chat(user, "<span class='bigdanger'>The gauntlets suddenly squeeze tight, crushing your arms before you manage to get them off!</span>")
			user.emote("scream")
			user.apply_damage(7, BRUTE, BP_L_HAND)
			user.apply_damage(7, BRUTE, BP_R_HAND)
		addtimer(CALLBACK(user, /mob.proc/unEquip, src), 1)

/obj/item/clothing/shoes/clockwork
	name = "clockwork treads"
	desc = "Industrial boots made of brass. They're very heavy."
	icon = 'infinity/icons/obj/clothing/clockwork_garb.dmi'
	icon_state = "clockwork_treads"

/obj/item/clothing/shoes/clockwork/equipped(mob/living/user, slot)
	..()
	if(slot == slot_shoes && !is_servant_of_ratvar(user))
		if(!iscultist(user))
			to_chat(user, "<span class='heavy_brass'>\"Now now, this is for my servants, not you.\"</span>")
			user.visible_message("<span class='warning'>As [user] puts [src] on, it flickers off their feet!</span>", "<span class='warning'>The treads flicker off your feet, leaving only nausea!</span>")
			if(ishuman(user))
				var/mob/living/carbon/human/H = user
				H.vomit()
		else
			to_chat(user, "<span class='heavy_brass'>\"Let's see if you can dance with these.\"</span>")
			to_chat(user, "<span class='userdanger'>The treads turn searing hot as you scramble to get them off!</span>")
			user.emote("scream")
			user.apply_damage(7, BURN, BP_L_FOOT)
			user.apply_damage(7, BURN, BP_R_FOOT)
		addtimer(CALLBACK(user, /mob.proc/unEquip, src), 1)