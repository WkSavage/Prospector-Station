/obj/item/clothing/accessory/holster
	name = "holster"
	desc = "A Gun Holster."
	icon_state = "holster"
	item_color = "holster"
	slot = "utility"
	var/holster_allow = /obj/item/weapon/gun
	var/storage_slots = 1
	var/can_hold = list("/obj/item/weapon/gun/projectile/colt",
		"/obj/item/weapon/gun/projectile/sec",
		"/obj/item/weapon/gun/projectile/silenced",
		"/obj/item/weapon/gun/projectile/deagle",
		"/obj/item/weapon/gun/projectile/pistol/flash",
		"/obj/item/weapon/gun/projectile/revolver",
		"/obj/item/weapon/gun/projectile/revolver/detective",
		"/obj/item/weapon/gun/projectile/colt/detective",
		"/obj/item/weapon/gun/energy/taser",
		"/obj/item/weapon/gun/energy/stunrevolver",
		"/obj/item/weapon/gun/energy",
		"/obj/item/weapon/gun/energy/gun")
	var/cannot_hold = list("/obj/item/weapon/gun/projectile/shotgun/pump",
		"/obj/item/weapon/gun/projectile/shotgun/pump/combat",
		"/obj/item/weapon/gun/projectile/shotgun/doublebarrel",
		"/obj/item/weapon/gun/projectile/heavysniper",
		"/obj/item/weapon/gun/projectile/automatic/c20r",
		"/obj/item/weapon/gun/energy/laser",
		"/obj/item/weapon/gun/energy/captain",
		"/obj/item/weapon/gun/energy/lasercannon",
		"/obj/item/weapon/gun/energy/sniperrifle",
		"/obj/item/weapon/gun/energy/gun/nuclear",
		"/obj/item/weapon/gun/energy/pulse_rifle")
	var/obj/item/weapon/gun/holstered = null
	action_button_name = "Holster"
	w_class = 3.0 // so it doesn't fit in pockets

//subtypes can override this to specify what can be holstered
/obj/item/clothing/accessory/holster/proc/can_holster(obj/item/weapon/gun/W)
	if(istype(W,cannot_hold))
		return 1
	if(!istype(W,holster_allow))
		return 0
	else
		return 1

/obj/item/clothing/accessory/holster/attack_self()
	var/holsteritem = usr.get_active_hand()
	if(!holstered)
		holster(holsteritem, usr)
	else
		unholster(usr)

/obj/item/clothing/accessory/holster/proc/holster(obj/item/I, mob/user as mob)
	if(holstered)
		user << "<span class='warning'>There is already a [holstered] holstered here!</span>"
		return

	if (!istype(I, /obj/item/weapon/gun))
		user << "<span class='warning'>Only guns can be holstered!</span>"
		return

	var/obj/item/weapon/gun/W = I
	if (!can_holster(W))
		user << "<span class='warning'>This [W] won't fit in the [src]!</span>"
		return

	holstered = W
	user.unEquip(holstered)
	holstered.loc = src
	holstered.add_fingerprint(user)
	user.visible_message("<span class='notice'>[user] holsters the [holstered].</span>", "<span class='notice'>You holster the [holstered].</span>")

/obj/item/clothing/accessory/holster/proc/unholster(mob/user as mob)
	if(!holstered)
		return

	if(istype(user.get_active_hand(),/obj) && istype(user.get_inactive_hand(),/obj))
		user << "<span class='warning'>You need an empty hand to draw the [holstered]!</span>"
	else
		if(user.a_intent == I_HURT)
			usr.visible_message("\red [user] draws the [holstered], ready to shoot!</span>", \
			"<span class='warning'>You draw the [holstered], ready to shoot!</span>")
		else
			user.visible_message("<span class='notice'>[user] draws the [holstered], pointing it at the ground.</span>", \
			"<span class='notice'>You draw the [holstered], pointing it at the ground.</span>")
		user.put_in_hands(holstered)
		holstered.add_fingerprint(user)
		holstered = null

/obj/item/clothing/accessory/holster/attack_hand(mob/user as mob)
	if (has_suit)	//if we are part of a suit
		if (holstered)
			unholster(user)
		return

	..(user)

/obj/item/clothing/accessory/holster/attackby(obj/item/W as obj, mob/user as mob, params)
	holster(W, user)

/obj/item/clothing/accessory/holster/emp_act(severity)
	if (holstered)
		holstered.emp_act(severity)
	..()

/obj/item/clothing/accessory/holster/examine(mob/user)
	..(user)
	if (holstered)
		user << "A [holstered] is holstered here."
	else
		user << "It is empty."

/obj/item/clothing/accessory/holster/on_attached(obj/item/clothing/under/S, mob/user as mob)
	..()
	has_suit.verbs += /obj/item/clothing/accessory/holster/verb/holster_verb

/obj/item/clothing/accessory/holster/on_removed(mob/user as mob)
	has_suit.verbs -= /obj/item/clothing/accessory/holster/verb/holster_verb
	..()

//For the holster hotkey
/obj/item/clothing/accessory/holster/verb/holster_verb()
	set name = "Holster"
	set category = "Object"
	set src in usr
	if(!istype(usr, /mob/living)) return
	if(usr.stat) return

	var/obj/item/clothing/accessory/holster/H = null
	if (istype(src, /obj/item/clothing/accessory/holster))
		H = src
	else if (istype(src, /obj/item/clothing/under))
		var/obj/item/clothing/under/S = src
		if (S.accessories.len)
			H = locate() in S.accessories

	if (!H)
		usr << "<span class='warning'>Something is very wrong.</span>"

	if(!H.holstered)
		if(!istype(usr.get_active_hand(), /obj/item/weapon/gun))
			usr << "<span class='warning'>You need your gun equiped to holster it.</span>"
			return
		var/obj/item/weapon/gun/W = usr.get_active_hand()
		H.holster(W, usr)
	else
		H.unholster(usr)

/obj/item/clothing/accessory/holster/armpit
	name = "armpit holster"
	desc = "A worn-out handgun holster. Perfect for concealed carry"
	icon_state = "holster"
	item_color = "holster"
	holster_allow = /obj/item/weapon/gun
	storage_slots = 1
	can_hold = list("/obj/item/weapon/gun/projectile/colt",
		"/obj/item/weapon/gun/projectile/sec",
		"/obj/item/weapon/gun/projectile/silenced",
		"/obj/item/weapon/gun/projectile/deagle",
		"/obj/item/weapon/gun/projectile/pistol/flash",
		"/obj/item/weapon/gun/projectile/revolver",
		"/obj/item/weapon/gun/projectile/revolver/detective",
		"/obj/item/weapon/gun/projectile/colt/detective",
		"/obj/item/weapon/gun/energy/taser",
		"/obj/item/weapon/gun/energy/stunrevolver",
		"/obj/item/weapon/gun/energy",
		"/obj/item/weapon/gun/energy/gun")
	cannot_hold = list("/obj/item/weapon/gun/projectile/shotgun/pump",
		"/obj/item/weapon/gun/projectile/shotgun/pump/combat",
		"/obj/item/weapon/gun/projectile/shotgun/doublebarrel",
		"/obj/item/weapon/gun/projectile/heavysniper",
		"/obj/item/weapon/gun/projectile/automatic/c20r",
		"/obj/item/weapon/gun/energy/laser",
		"/obj/item/weapon/gun/energy/captain",
		"/obj/item/weapon/gun/energy/lasercannon",
		"/obj/item/weapon/gun/energy/sniperrifle",
		"/obj/item/weapon/gun/energy/gun/nuclear",
		"/obj/item/weapon/gun/energy/pulse_rifle"
		)

/obj/item/clothing/accessory/holster/waist
	name = "waist holster"
	desc = "A handgun holster. Made of expensive leather."
	icon_state = "holster"
	item_color = "holster_low"
	holster_allow = /obj/item/weapon/gun
	storage_slots = 1
	can_hold = list("/obj/item/weapon/gun/projectile/colt",
		"/obj/item/weapon/gun/projectile/sec",
		"/obj/item/weapon/gun/projectile/silenced",
		"/obj/item/weapon/gun/projectile/deagle",
		"/obj/item/weapon/gun/projectile/pistol/flash",
		"/obj/item/weapon/gun/projectile/revolver",
		"/obj/item/weapon/gun/projectile/revolver/detective",
		"/obj/item/weapon/gun/projectile/colt/detective",
		"/obj/item/weapon/gun/energy/taser",
		"/obj/item/weapon/gun/energy/stunrevolver",
		"/obj/item/weapon/gun/energy")
	cannot_hold = list("/obj/item/weapon/gun/projectile/shotgun/pump",
		"/obj/item/weapon/gun/projectile/shotgun/pump/combat",
		"/obj/item/weapon/gun/projectile/shotgun/doublebarrel",
		"/obj/item/weapon/gun/projectile/heavysniper",
		"/obj/item/weapon/gun/projectile/automatic/c20r",
		"/obj/item/weapon/gun/energy/laser",
		"/obj/item/weapon/gun/energy/captain",
		"/obj/item/weapon/gun/energy/lasercannon",
		"/obj/item/weapon/gun/energy/sniperrifle",
		"/obj/item/weapon/gun/energy/gun/nuclear",
		"/obj/item/weapon/gun/energy/pulse_rifle"
		)

/obj/item/clothing/accessory/holster/hip
	name = "hip holster"
	desc = "A handgun holster slung low on the hip, draw pardner!"
	icon_state = "holster_hip"
	item_color = "holster_hip"
	holster_allow = /obj/item/weapon/gun
	storage_slots = 1
	can_hold = list("/obj/item/weapon/gun/projectile/colt",
		"/obj/item/weapon/gun/projectile/sec",
		"/obj/item/weapon/gun/projectile/silenced",
		"/obj/item/weapon/gun/projectile/deagle",
		"/obj/item/weapon/gun/projectile/pistol/flash",
		"/obj/item/weapon/gun/projectile/revolver",
		"/obj/item/weapon/gun/projectile/revolver/detective",
		"/obj/item/weapon/gun/projectile/colt/detective",
		"/obj/item/weapon/gun/energy/taser",
		"/obj/item/weapon/gun/energy/stunrevolver",
		"/obj/item/weapon/gun/energy")
	cannot_hold = list("/obj/item/weapon/gun/projectile/shotgun/pump",
		"/obj/item/weapon/gun/projectile/shotgun/pump/combat",
		"/obj/item/weapon/gun/projectile/shotgun/doublebarrel",
		"/obj/item/weapon/gun/projectile/heavysniper",
		"/obj/item/weapon/gun/projectile/automatic/c20r",
		"/obj/item/weapon/gun/energy/laser",
		"/obj/item/weapon/gun/energy/captain",
		"/obj/item/weapon/gun/energy/lasercannon",
		"/obj/item/weapon/gun/energy/sniperrifle",
		"/obj/item/weapon/gun/energy/gun/nuclear",
		"/obj/item/weapon/gun/energy/pulse_rifle"
		)
