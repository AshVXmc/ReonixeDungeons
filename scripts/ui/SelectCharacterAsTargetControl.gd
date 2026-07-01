class_name SelectCharacterAsTargetControl extends Control

export(int, 1, 3) var selected_character_index : int = 0

const PLAYER_ICON = preload("res://assets/UI/player_character_icon.png")
const GLACIELA_ICON = preload("res://assets/UI/glaciela_character_icon.png")
const AGNETTE_ICON = preload("res://assets/UI/agnette_character_icon.png")
const EMPTY_ICON = preload("res://assets/UI/empty_character_icon.png")

func _ready():
	update_ui()

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

func _on_CloseButtonCharacterOptionsListUI_pressed():
	pass # Replace with function body.
