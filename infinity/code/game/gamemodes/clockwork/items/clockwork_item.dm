//The base clockwork item. Can have an alternate desc and will show up in the list of clockwork objects.
/obj/item/weapon/clockwork
	name = "meme blaster"
	desc = "What the fuck is this? It looks kinda like an ipad."
	var/clockwork_desc = "A fabled artifact from beyond the stars. Contains concentrated meme essence."
	icon = 'infinity/icons/obj/clockwork_objects.dmi'
	icon_state = "dread_ipad"
	w_class = ITEM_SIZE_SMALL

/obj/item/weapon/clockwork/examine(mob/user)
	if((is_servant_of_ratvar(user) || isobserver(user)) && clockwork_desc)
		desc = clockwork_desc
	. = ..()
	desc = initial(desc)
