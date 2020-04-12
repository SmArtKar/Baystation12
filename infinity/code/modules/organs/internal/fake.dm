/obj/item/organ/internal/fake_brain
	name = "strange brain"
	desc = "A piece of meat found in a person's head. It's dry and light - \
	as if it was full of air without access to brainfluid."
	organ_tag = BP_FAKE
	parent_organ = BP_HEAD
	icon_state = "brain2"
	force = 1
	w_class = ITEM_SIZE_SMALL
	throwforce = 1
	throw_speed = 3
	throw_range = 5
	origin_tech = list(TECH_BIO = 1)
	attack_verb = list("attacked", "slapped", "whacked")
	relative_size = 85
	damage_reduction = 0
	can_be_printed = FALSE

/obj/item/organ/internal/romerol
	name = "festering ooze"
	desc = "A piece of festering meat. At first sight it may look as a piece of brain, but if you look closer, you can spot some strange, green moving veins in it."
	organ_tag = BP_ZOMB
	parent_organ = BP_HEAD
	icon_state = "roro core"
	force = 1
	w_class = ITEM_SIZE_SMALL
	throwforce = 1
	throw_speed = 3
	throw_range = 5
	origin_tech = list(TECH_BIO = 1)
	attack_verb = list("attacked", "slapped", "whacked")
	relative_size = 85
	damage_reduction = 0
	can_be_printed = FALSE
	var/progress = 0
	var/max_progress = 100

/obj/item/organ/internal/romerol/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/item/organ/internal/romerol/replaced(var/mob/living/carbon/human/target, var/needed_progress)
	if(!..()) return 0

	if(owner && ishuman(owner))
		max_progress = needed_progress

/obj/item/organ/internal/romerol/Process()
	if(owner)
		if(progress < max_progress)
			progress++
		else
			owner.zombify()
			qdel(src)
	. = ..()