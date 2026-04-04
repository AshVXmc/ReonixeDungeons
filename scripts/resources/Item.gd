class_name Item extends Resource


export(int) var item_id # use to identify the item
export(String) var item_name # can be changed for flavor
export(int) var item_category 
export(String) var item_description 
export(String) var item_texture_path

enum ID {
	HEALTH_POTION,
	LARGE_HEALTH_POTION,
	MANA_POTION
}

# NOTE: Names have to be distinct from each other.
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
	LARGE_HEALTH_POTION = "res://assets/misc/large_health_pot.png",
	MANA_POTION = "res://assets/misc/mana_pot.png"
}

func get_id():
	return item_id
 
func get_name():
	return item_name

func get_category():
	return item_category

func get_description():
	return item_description
	
func get_item_texture_path():
	return item_texture_path

func _init(identifier = ""):
	match identifier:
		ID.HEALTH_POTION:
			item_id = ID.HEALTH_POTION
			item_name = NAME.HEALTH_POTION
			item_category = CATEGORY.POTIONS
			item_description = DESCRIPTION.HEALTH_POTION
			item_texture_path = TEXTURE_PATH.HEALTH_POTION
		ID.LARGE_HEALTH_POTION:
			item_id = ID.LARGE_HEALTH_POTION
			item_name = NAME.LARGE_HEALTH_POTION
			item_category = CATEGORY.POTIONS
			item_description = DESCRIPTION.LARGE_HEALTH_POTION
			item_texture_path = TEXTURE_PATH.LARGE_HEALTH_POTION
	



