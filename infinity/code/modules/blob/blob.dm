/obj/effect/biomass
	name = "pulsating mass"
	desc = "A pulsating mass of interwoven tendrils."
	icon = 'infinity/icons/mob/blob.dmi'
	icon_state = "blob"
	light_outer_range = 2
	light_color = BLOB_COLOR_PULS
	density = 1
	anchored = 1
	mouse_opacity = 2

	layer = BLOB_SHIELD_LAYER

	var/maxHealth = 30
	var/health
	var/regen_rate = 5
	var/blob_color = "#8BA6E9"
	var/tendril_damage_types = list(BRUTE)
	var/tendril_damages = list(BRUTE = 30)
	var/brute_resist = 0.25
	var/fire_resist = 0.5
	var/laser_resist = 0.5
	var/bomb_resist = 0.75
	var/pulsing = 1

	var/obj/effect/biomass/core/core
	var/refund_value = 2

/obj/effect/biomass/proc/readapt()
	blob_color = core.blob_color
	tendril_damage_types = core.tendril_damage_types
	tendril_damages = core.tendril_damages
	brute_resist = core.brute_resist
	fire_resist = core.fire_resist
	laser_resist = core.laser_resist
	bomb_resist = core.bomb_resist
	pulsing = core.pulsing

/obj/effect/biomass/Initialize(loc)
	health = maxHealth
	update_icon()
	START_PROCESSING(SSobj, src)
	. = ..()

/obj/effect/biomass/on_update_icon()
	if(health > maxHealth / 2)
		icon_state = "[initial(icon_state)]"
	else
		icon_state = "[initial(icon_state)]_damaged"

	color = blob_color
	light_color = blob_color

/obj/effect/biomass/CanPass(var/atom/movable/mover, var/turf/target, var/height = 0, var/air_group = 0)
	if(air_group || height == 0)
		return 1

	if(istype(mover, /mob/living))
		var/mob/living/mob = mover
		if(mob.faction == "blob")
			return 1

	return 0

/obj/effect/biomass/ex_act(var/severity)
	switch(severity)
		if(1)
			take_damage(rand(100, 120) * brute_resist * bomb_resist)
		if(2)
			take_damage(rand(60, 100) * brute_resist * bomb_resist)
		if(3)
			take_damage(rand(20, 60) * brute_resist * bomb_resist)

/obj/effect/biomass/proc/take_damage(var/damage)
	health -= damage
	playsound(loc, 'sound/effects/splat.ogg', 50, 1)
	if(health < 0)
		core.strain.killed(src)
		qdel(src)
	else
		update_icon()

/obj/effect/biomass/proc/regen()
	health = min(health + regen_rate, maxHealth)
	update_icon()

/obj/effect/biomass/proc/expand(var/turf/T, var/manual = 0)
	if(manual)
		if(core.resources >= 4)
			core.resources -= 4
		else
			to_chat(core.blobHolder, "You at least 4 resources to do this!")
			return


	if(istype(T, /turf/unsimulated/) || (istype(T, /turf/simulated/mineral) && T.density))
		return

	if(istype(T, /turf/space) && (prob(75) || !manual))
		return

	playsound(loc, 'sound/effects/attackblob.ogg', 50, 1)

	if(istype(T, /turf/simulated/wall))
		var/turf/simulated/wall/SW = T
		SW.take_damage(40)
		return
	var/obj/structure/girder/G = locate() in T
	if(G)
		if(prob(40))
			G.dismantle()
		return
	var/obj/structure/window/W = locate() in T
	if(W)
		W.shatter()
		return
	var/obj/structure/grille/GR = locate() in T
	if(GR)
		qdel(GR)
		return
	for(var/obj/structure/S in T)
		if(S.density)
			if(prob(75))
				S.ex_act(2)
			return
	for(var/obj/machinery/M in T)
		if(M.density)
			M.ex_act(2)
			return
		else
			if(istype(M, /obj/machinery/power))
				M.ex_act(2)
	for(var/obj/machinery/door/D in T)
		if(D.density)
			D.ex_act(2)
			return
	var/obj/structure/foamedmetal/F = locate() in T
	if(F)
		qdel(F)
		return
	var/obj/structure/inflatable/I = locate() in T
	if(I)
		I.deflate(1)
		return

	var/obj/vehicle/V = locate() in T
	if(V)
		V.ex_act(2)
		return
	var/obj/machinery/camera/CA = locate() in T
	if(CA)
		CA.ex_act(2)

	for(var/mob/living/L in T)
		if(L.stat == DEAD || L.faction == "blob")
			continue
		else
			attack_living(L)
			return

	var/obj/effect/biomass/new_blob = new(T)
	new_blob.color = color
	new_blob.core = core
	core.strain.expanded(src, new_blob)


/obj/effect/biomass/proc/attack_living(var/mob/living/L)
	if(!L)
		return
	L.visible_message(SPAN_DANGER("A tendril flies out from \the [src] and smashes into \the [L]!"), SPAN_DANGER("A tendril flies out from \the [src] and smashes into you!"))
	playsound(loc, 'sound/effects/attackblob.ogg', 50, 1)
	core.strain.attack(src, L)
	for(var/blob_damage in tendril_damage_types)
		L.apply_damage(tendril_damages[blob_damage], blob_damage, used_weapon = "blob tendril")

/obj/effect/biomass/emp_act(var/severity)
	core.strain.damaged(src, severity)

/obj/effect/biomass/proc/pulse(var/forceLeft, var/list/dirs)
	sleep(2)
	if(!pulsing)
		core.resources += core.resource_gain
		return
	var/pushDir = pick(dirs)
	var/turf/T = get_step(src, pushDir)
	var/obj/effect/biomass/B = (locate() in T)
	if(!B)
		if(prob(health))
			expand(T, 0)
		return

	if(prob(forceLeft))
		reinforce(0)

	if(prob(20 - forceLeft))
		if(!core.blobHolder && !(istype(src, /obj/effect/biomass/core) || istype(src, /obj/effect/biomass/node) || istype(src, /obj/effect/biomass/factory) || istype(src, /obj/effect/biomass/spore)))
			for(var/obj/effect/biomass/node/blob in range(get_turf(src), 5))
				return
			for(var/obj/effect/biomass/factory/blob in range(get_turf(src), 5))
				return
			for(var/obj/effect/biomass/core/blob in range(get_turf(src), 5))
				return
			for(var/obj/effect/biomass/spore/blob in range(get_turf(src), 5))
				return

			var/blob_type = pick(/obj/effect/biomass/node, /obj/effect/biomass/factory, /obj/effect/biomass/spore)
			var/obj/effect/biomass/new_blob = new blob_type(get_turf(src))
			new_blob.core = src.core
			qdel(src)

	if(forceLeft)
		B.pulse(forceLeft - 1, dirs)

/obj/effect/biomass/proc/reinforce(var/manual = 0)
	if(!manual)
		var/obj/effect/biomass/reinforced/new_blob = new(get_turf(src))
		new_blob.color = color
		new_blob.core = src.core
		qdel(src)
		return

	if(core.resources >= 15)
		core.resources -= 15
		var/obj/effect/biomass/reinforced/new_blob = new(get_turf(src))
		new_blob.color = color
		new_blob.core = src.core
		refund_value += 7
		new_blob.refund_value = refund_value
		qdel(src)

/obj/effect/biomass/Process()
	if(core)
		regen()
		readapt()
		update_icon()

/obj/effect/biomass/bullet_act(var/obj/item/projectile/Proj)
	if(!Proj)
		return

	core.strain.damaged(src, Proj.firer, 1)

	switch(Proj.damage_type)
		if(BRUTE)
			take_damage(Proj.damage * brute_resist)
		if(BURN)
			take_damage((Proj.damage * laser_resist) * fire_resist)
	return 0

/obj/effect/biomass/attackby(var/obj/item/weapon/W, var/mob/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.do_attack_animation(src)
	playsound(loc, 'sound/effects/attackblob.ogg', 50, 1)

	var/damage = 0
	switch(W.damtype)
		if("fire")
			damage = (W.force * fire_resist)
			if(isWelder(W))
				playsound(loc, 'sound/items/Welder.ogg', 100, 1)
		if("brute")
			damage = (W.force * brute_resist)

	take_damage(damage)

	core.strain.damaged(src, user)

	return




/obj/effect/biomass/core
	name = "master nucleus"
	desc = "A massive, fragile nucleus guarded by a shield of thick tendrils."
	icon_state = "blob_core"
	maxHealth = 450

	light_color = BLOB_COLOR_CORE
	layer = BLOB_CORE_LAYER

	var/resources = 0
	var/resource_gain = 1

	var/mob/living/blobHolder/blobHolder

	var/datum/blob_strain/strain

/obj/effect/biomass/core/take_damage(var/damage)
	health -= damage
	playsound(loc, 'sound/effects/splat.ogg', 50, 1)
	if(health < 0)
		core.strain.killed(src)
		blobHolder.eye.release(blobHolder)
		qdel(blobHolder.eye)
		qdel(blobHolder)
		qdel(src)
	else
		update_icon()

/obj/effect/biomass/core/Initialize()
	. = ..()
	core = src
	var/strain_type = pick(subtypesof(/datum/blob_strain))
	strain = new strain_type
	update_icon()

/obj/effect/biomass/core/readapt()
	blob_color = strain.blob_color
	tendril_damage_types = strain.tendril_damage_types
	tendril_damages = strain.tendril_damages
	brute_resist = strain.brute_resist
	fire_resist = strain.fire_resist
	laser_resist = strain.laser_resist
	bomb_resist = strain.bomb_resist
	pulsing = strain.pulsing
	resource_gain = strain.resource_gain

/obj/effect/biomass/core/Process()
	resources += resource_gain
	regen()
	pulse(20, GLOB.alldirs)
	readapt()
	update_icon()
	update_icon()

/obj/effect/biomass/core/on_update_icon()
	color = blob_color
	light_color = blob_color
	overlays.Cut()
	overlays += image(icon, "blob_core_overlay")

/obj/effect/biomass/core/reinforce()
	return



/obj/effect/biomass/node
	name = "secondary core"
	desc = "A glowing yellow core in a sphere of tendrils."
	icon_state = "blob_node"

	maxHealth = 50

/obj/effect/biomass/node/Process()
	if(core)
		regen()
		pulse(10, GLOB.alldirs)
		readapt()
		update_icon()
		update_icon()

/obj/effect/biomass/node/on_update_icon()
	. = ..()
	overlays.Cut()
	overlays += image(icon, "blob_node_overlay")

/obj/effect/biomass/node/reinforce()
	return



/obj/effect/biomass/factory
	name = "producing mass"
	desc = "A strange filtrating blob guarded by a shield of tendrils. It looks fragile."
	icon_state = "blob_resource"

	maxHealth = 20

/obj/effect/biomass/factory/reinforce()
	return

/obj/effect/biomass/factory/pulse()
	core.resources += core.resource_gain
	. = ..()



/obj/effect/biomass/spore
	name = "producing mass"
	desc = "A strange filtrating blob guarded by a shield of tendrils. It looks fragile."
	icon_state = "blob_factory"

	maxHealth = 40
	var/progress = 0

/obj/effect/biomass/spore/pulse()
	progress++
	if(progress == 30)
		var/mob/living/simple_animal/hostile/blobspore/infesting/spore = new(get_turf(src))
		spore.color = color
		progress = 0
	. = ..()



/obj/effect/biomass/spore/reinforce()
	return



/obj/effect/biomass/reinforced
	name = "ravaging mass"
	desc = "A mass of interwoven tendrils. They thrash around haphazardly at anything in reach."
	icon_state = "blob_shield"

	maxHealth = 80

/obj/effect/biomass/reinforced/reinforce(manual = 0)
	if(!manual)
		var/obj/effect/biomass/shield/new_blob = new(get_turf(src))
		new_blob.color = color
		new_blob.core = src.core
		qdel(src)
		return

	if(core.resources >= 15)
		core.resources -= 15
		var/obj/effect/biomass/shield/new_blob = new(get_turf(src))
		new_blob.color = color
		new_blob.core = src.core
		qdel(src)

/obj/effect/biomass/shield
	name = "shielding mass"
	desc = "A pulsating mass of interwoven tendrils. These seem particularly robust, but not quite as active."
	icon_state = "blob_idle_glow"

	maxHealth = 120

/obj/effect/biomass/shield/reinforce()
	return