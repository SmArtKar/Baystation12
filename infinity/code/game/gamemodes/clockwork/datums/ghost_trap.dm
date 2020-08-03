/datum/ghosttrap/clockwork_brain
	object = "soul vessel"
	ban_checks = list("Dionaea")
	pref_check = BE_PLANT
	ghost_trap_message = "They are occupying a soul vessel now."
	ghost_trap_role = "Soul Vessel"

/datum/ghosttrap/clockwork_brain/welcome_candidate(var/mob/target)
	to_chat(target, "<b>You are a soul vessel - a clockwork mind created by Ratvar, the Clockwork Justiciar.\n\
	You answer to Ratvar and his servants. It is your discretion as to whether or not to answer to anyone else.\n\
	The purpose of your existence is to further the goals of the servants and Ratvar himself. Above all else, serve Ratvar.</b>")
	var/obj/item/organ/internal/posibrain/soul_vessel/P = target.loc
	if(!istype(P))
		return
	P.PickName()
	P.visible_message("<span class='brass'>The cogwheel's rotation smooths out as the soul vessel activates.</span>")
	P.searching = 0
	P.icon_state = "soul_vessel-occupied"
	P.SetName("soul vessel ([P.brainmob.name])")
	P.update_icon()

/datum/ghosttrap/clockwork_brain/transfer_personality(var/mob/candidate, var/mob/target)
	if(!assess_candidate(candidate, target))
		return 0
	target.ckey = candidate.ckey
	if(target.mind)
		target.mind.reset()
		target.mind.assigned_role = "[ghost_trap_role]"
	announce_ghost_joinleave(candidate, 0, "[ghost_trap_message]")
	welcome_candidate(target)
	//GLOB.clockwork_cult.add_antagonist(target.mind, ignore_role = 1, do_not_equip = 1)
	return 1
