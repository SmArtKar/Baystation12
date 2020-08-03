
/mob/living/silicon/proc/change_clockwork()
	//GLOB.clockwork_cult.add_antagonist(src.mind, ignore_role = 1, do_not_equip = 1) //Just in case
	var/datum/ai_laws/ratvar/laws = new()
	laws.sync(src, 1)
