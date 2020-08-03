/obj/item/organ/internal/posibrain/soul_vessel
	name = "soul vessel"
	desc = "A heavy brass cube, three inches to a side, with a single protruding cogwheel."

	var/clockwork_desc = "A soul vessel, an ancient relic that can attract the souls of the damned or simply rip a mind from an unconscious or dead human.\n\
	<span class='brass'>If active, can serve as a positronic brain, placable in cyborg shells or clockwork construct shells.</span>"

	icon = 'infinity/icons/obj/clockwork_objects.dmi'
	icon_state = "soul_vessel"


	origin_tech = list(TECH_ENGINEERING = 6, TECH_MATERIAL = 3, TECH_BLUESPACE = 4)


	req_access = list()
	shackled_verbs = list()

/obj/item/organ/internal/posibrain/soul_vessel/New()
	. = ..()
	name = "soul vessel" //Needed in New

/obj/item/organ/internal/posibrain/soul_vessel/examine(mob/user)
	if((is_servant_of_ratvar(user) || isobserver(user)) && clockwork_desc)
		desc = clockwork_desc
	. = ..()
	desc = initial(desc)

/obj/item/organ/internal/posibrain/soul_vessel/attack_self(mob/living/user)
	if(!is_servant_of_ratvar(user))
		to_chat(user, "<span class='warning'>You fiddle around with [src], to no avail.</span>")
		return FALSE
	. = ..()

/obj/item/organ/internal/posibrain/soul_vessel/PickName()
	src.brainmob.SetName("[pick(list("Hehaze","Iaeq","Seueq","Naberza","Utawg"))]-[random_id(type,100,999)]")
	src.brainmob.real_name = src.brainmob.name

/obj/item/organ/internal/posibrain/soul_vessel/attack_self(mob/user as mob)
	if(brainmob && !brainmob.key && searching == 0)
		to_chat(user, "<span class='brass'>You activate the cogwheel. It hitches and stalls as it begins spinning.</span>")
		icon_state = "soul_vessel-searching"
		searching = 1
		var/datum/ghosttrap/clockwork_brain/G = get_ghost_trap("soul vessel")
		G.request_player(brainmob, "Someone is requesting a personality for a soul vessel!", 60 SECONDS)
		spawn(600) reset_search()

/obj/item/organ/internal/posibrain/soul_vessel/reset_search() //We give the players sixty seconds to decide, then reset the timer.
	if(src.brainmob && src.brainmob.key) return

	searching = 0
	icon_state = "soul_vessel"

	visible_message("<span class='warning'>The cogwheel creaks and grinds to a halt. Maybe you could try again?</span>")

/obj/item/organ/internal/posibrain/soul_vessel/attack_ghost(var/mob/observer/ghost/user)
	if(src.brainmob && src.brainmob.key)
		return

	var/datum/ghosttrap/G = get_ghost_trap("soul vessel")
	if(!G.assess_candidate(user))
		return
	var/response = alert(user, "Are you sure you wish to possess this [src]?", "Possess [src]", "Yes", "No")
	if(response == "Yes")
		G.transfer_personality(user, brainmob)
	return

/obj/item/organ/internal/posibrain/soul_vessel/on_update_icon()
	if(src.brainmob && src.brainmob.key)
		icon_state = "soul_vessel-occupied"
	else
		icon_state = "soul_vessel"

/obj/item/organ/internal/posibrain/soul_vessel/attack(mob/living/target, mob/living/carbon/human/user)
	if(!is_servant_of_ratvar(user) || !ishuman(target))
		. = ..()
		return

	var/datum/ghosttrap/G = get_ghost_trap("soul vessel")

	if(QDELETED(brainmob))
		return

	if(brainmob.key)
		to_chat(user, "<span class='nezbere'>\"This vessel is filled, friend. Provide it with a body.\"</span>")
		return

	if(is_servant_of_ratvar(target))
		to_chat(user, "<span class='nezbere'>\"It would be more wise to revive your allies, friend.\"</span>")
		return

	var/mob/living/carbon/human/H = target
	if(H.stat == CONSCIOUS)
		to_chat(user, "<span class='warning'>[H] must be dead or unconscious for you to claim their mind!</span>")
		return

	if(H.head)
		var/obj/item/I = H.head
		if(I.flags_inv & BLOCKHAIR)
			to_chat(user, "<span class='warning'>[H]'s head is covered, remove [H.head] first!</span>")
			return

	if(H.wear_mask)
		var/obj/item/I = H.wear_mask
		if(I.flags_inv & BLOCKHAIR)
			to_chat(user, "<span class='warning'>[H]'s head is covered, remove [H.wear_mask] first!</span>")
			return

	var/obj/item/organ/external/head/head = H.get_organ(BP_HEAD)

	if(!head)
		to_chat(user, "<span class='warning'>[H] has no head, and thus no mind to claim!</span>")
		return

	var/obj/item/organ/internal/brain/B = H.get_organ(BP_BRAIN)

	if(!B)
		to_chat(user, "<span class='warning'>[H] has no brain, and thus no mind to claim!</span>")
		return

	if(!H.key) //nobody's home
		to_chat(user, "<span class='warning'>[H] has no mind to claim!</span>")
		return

	if(!G.assess_candidate(target, src))
		to_chat(user, "<span class='warning'>[H]'s brain doesn't fit inside!</span>")
		return

	playsound(H, 'infinity/sound/misc/clockwork/anima_fragment_attack.ogg', 40, 1, -1)
	H.death()
	user.visible_message("<span class='warning'>[user] presses [src] to [H]'s head, ripping through the skull and carefully extracting the brain!</span>", \
	"<span class='brass'>You extract [H]'s consciousness from their body, trapping it in the soul vessel.</span>")
	B.removed(H, 0)
	H.ghostize()

	G.transfer_personality(user, brainmob)

	brainmob.SetName("Slave [H.real_name]")
	brainmob.real_name = src.brainmob.name
	name = "[initial(name)] ([brainmob.name])"

	qdel(B)

