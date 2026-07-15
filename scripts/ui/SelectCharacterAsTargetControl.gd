class_name SelectCharacterAsTargetControl extends Control

export(int, 1, 3) var selected_character_index : int = 0

const PLAYER_ICON = preload("res://assets/UI/player_character_icon.png")
const GLACIELA_ICON = preload("res://assets/UI/glaciela_character_icon.png")
const AGNETTE_ICON = preload("res://assets/UI/agnette_character_icon.png")
const EMPTY_ICON = preload("res://assets/UI/empty_character_icon.png")
const item = preload("res://scripts/resources/Item.gd")
var currently_selected_item : item 

func _ready():
	update_ui()
	visible = false

func update_ui():
	var index : int = 1
	for character in Global.equipped_characters:
		var button : TextureButton = get_node("Character" + str(index))
		match character:
			"Player":
				button.texture_normal = PLAYER_ICON
			"Glaciela":
				button.texture_normal = GLACIELA_ICON
			"Agnette":
				button.texture_normal = AGNETTE_ICON
		index += 1

	# update circular health bar
	$Character1/CircularHealthBar.max_value = Global.max_hearts
	$Character1/CircularHealthBar.value = Global.hearts
	$Character2/CircularHealthBar.max_value = Global.character2_hearts
	$Character2/CircularHealthBar.value = Global.character_2_max_hearts
	$Character3/CircularHealthBar.max_value = Global.character3_hearts
	$Character3/CircularHealthBar.value = Global.character_3_max_hearts

func open_ui(selected_item : item):
	update_ui()
	visible = true
	currently_selected_item = selected_item

func close_ui():
	visible = false

func consume_item(selected_character : String):
	if currently_selected_item.get_name() == "Health Potion":
		print(selected_character + "receives healing potion!")



func _on_CloseButtonCharacterOptionsListUI_pressed():
	pass

func _on_Character1_pressed():
	consume_item(Global.equipped_characters[0])

func _on_Character2_pressed():
	consume_item(Global.equipped_characters[1])

func _on_Character3_pressed():
	consume_item(Global.equipped_characters[2])
