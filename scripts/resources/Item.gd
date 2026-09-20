class_name Item extends Resource


export(int) var item_id # use to identify the item
export(String) var item_name # can be changed for flavor
export(int) var item_category 
export(String) var item_description 
export(String) var item_texture_path

enum ID {
	HEALTH_POTION,
	LARGE_HEALTH_POTION,
	MANA_POTION,
	REVIVIFY_SPELL_SCROLL
}

# NOTE: Names have to be distinct from each other.
const NAME := {
	HEALTH_POTION = "Health Potion",
	LARGE_HEALTH_POTION = "Large Health Potion",
	MANA_POTION = "Mana Potion",
	REVIVIFY_SPELL_SCROLL = "Revivify Spell Scroll"
}

enum CATEGORY {
	POTIONS,
	SPELL_SCROLLS,
	MISCELLANEOUS
}

const DESCRIPTION := {
	HEALTH_POTION = "[color=#ffd703]Health Potion[/color]: Restores a small amount of health to one character.",
	LARGE_HEALTH_POTION = "[color=#ffd703]Large Health Potion[/color]: Restores a moderate amount of health to one character.",
	MANA_POTION = "[color=#ffd703]Mana Potion[/color]: It glows in the dark. Restores MANA_RESTORED Mana to the on-field character.",
	REVIVIFY_SPELL_SCROLL = "[color=#ffd703]Revivify Spell Scroll[/color]: lorem ipsum"
}

const TEXTURE_PATH := {
	HEALTH_POTION = "res://assets/items/health_pot.png",
	LARGE_HEALTH_POTION = "res://assets/items/large_health_pot.png",
	MANA_POTION = "res://assets/items/mana_pot.png",
	REVIVIFY_SPELL_SCROLL = "res://assets/items/spell_scroll_revivify.png"
}

const health_restored := {
	HEALTH_POTION = 2,
	LARGE_HEALTH_POTION = 5
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

func get_amount_of_healing_granted():
	return 0

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
		ID.MANA_POTION:
			item_id = ID.MANA_POTION
			item_name = NAME.MANA_POTION
			item_category = CATEGORY.POTIONS
			item_description = DESCRIPTION.MANA_POTION
			item_texture_path = TEXTURE_PATH.MANA_POTION
		ID.REVIVIFY_SPELL_SCROLL:
			item_id = ID.REVIVIFY_SPELL_SCROLL
			item_name = NAME.REVIVIFY_SPELL_SCROLL
			item_category = CATEGORY.SPELL_SCROLLS
			item_description = DESCRIPTION.REVIVIFY_SPELL_SCROLL
			item_texture_path = TEXTURE_PATH.REVIVIFY_SPELL_SCROLL
	



