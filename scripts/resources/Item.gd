class_name Item extends Resource

export(String) var item_id # use to identify the item
export(String) var item_name # can be changed for flavor
export(String) var item_category 
export(String) var item_description 
export(String) var item_texture_path
export(int) var item_count

enum ID {
	HEALTH_POTION,
	LARGE_HEALTH_POTION,
	MANA_POTION
}

const NAME := {
	HEALTH_POTION = "Health Potion",
	LARGE_HEALTH_POTION = "Large Health Potion",
	MANA_POTION = "Mana Potion"
}

enum CATEGORY {
	POTIONS,
	MATERIALS,
	MISCELLANEOUS
}

const DESCRIPTION := {
	HEALTH_POTION = "An oddly sweet elixir. Restores HEALTH_RESTORED HP the on-field character.",
	LARGE_HEALTH_POTION = "An oddly sweet elixir, upsized. Restores HEALTH_RESTORED HP the on-field character.",
	MANA_POTION = "It glows in the dark. Restores MANA_RESTORED Mana to the on-field character."
}

const TEXTURE_PATH := {
	HEALTH_POTION = "res://assets/misc/health_pot.png",
	LARGE_HEALTH_POTION = "res://assets/misc/health_pot.png",
	MANA_POTION = "res://assets/misc/mana_pot.png"
}

const databank_of_items : Dictionary = {
	"HealthPotion" : [ID.HEALTH_POTION, NAME.HEALTH_POTION, CATEGORY.POTIONS, DESCRIPTION.HEALTH_POTION, TEXTURE_PATH.HEALTH_POTION],
	"LargeHealthPotion" : [ID.LARGE_HEALTH_POTION, NAME.LARGE_HEALTH_POTION, CATEGORY.POTIONS, DESCRIPTION.LARGE_HEALTH_POTION, TEXTURE_PATH.LARGE_HEALTH_POTION],
	"ManaPotion": [ID.MANA_POTION, NAME.MANA_POTION, CATEGORY.POTIONS, DESCRIPTION.MANA_POTION, TEXTURE_PATH.MANA_POTION]
}

func _init(p_item_id = null, p_item_name = null, p_item_category = null, p_item_description = null, p_item_texture_path = null, p_item_count = null):
	item_id = p_item_id
	item_name = p_item_name
	item_category = p_item_category
	item_description = p_item_description
	item_texture_path = p_item_texture_path
	item_count = p_item_count


