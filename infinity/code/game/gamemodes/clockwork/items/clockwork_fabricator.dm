//Replica Fabricator: Converts applicable objects to Ratvarian variants.
/obj/item/clockwork/replica_fabricator
	name = "replica fabricator"
	desc = "An odd, L-shaped device that hums with energy."
	clockwork_desc = "A device that allows the replacing of mundane objects with Ratvarian variants. It requires power to function."
	icon_state = "replica_fabricator"
	lefthand_file = 'icons/mob/inhands/antag/clockwork_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/antag/clockwork_righthand.dmi'
	w_class = ITEM_SIZE_NORMAL
	force = 5
	var/speed_multiplier = 1 //The speed ratio the fabricator operates at
	var/uses_power = TRUE
	var/repairing = null //what we're currently repairing, if anything