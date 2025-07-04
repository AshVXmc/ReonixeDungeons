class_name CharacterSkinSelectionUI extends Control

onready var player_vbox : VBoxContainer = $NinePatchRect/SkinSelectionControl/PlayerControl/ScrollContainer/VBoxContainer
onready var PLAYER : Player = get_parent().get_parent().get_parent().get_node("Player")
#onready var a : Texture = load("res://assets/weapons/scimitar.png")

signal change_player_weapon_skin(new_skin) # type: Texture

func _ready():
	initialize_ui()
	
	
func initialize_ui():
	var all_player_equip_skin_buttons : Array = []
	var player_weapon_skin_control_count : int = player_vbox.get_children().size()
	var player_weapon_skin_counter : int = 1
	
	while player_weapon_skin_counter < player_weapon_skin_control_count:
		 # 2 is the index position of the playerweaponskin button
		var button = player_vbox.get_node("WeaponSkin" + str(player_weapon_skin_counter) + "/" + str(player_weapon_skin_counter) +"_PlayerWeaponSkinEquipButton")
		button.connect("pressed", self, "on_PlayerWeaponSkinEquipButton_pressed", [button])
		player_weapon_skin_counter += 1

	connect("change_player_weapon_skin", PLAYER, "change_weapon_skin")

# NOTE: do not connect this function through the editor.
# do it through this piece of code.
func on_PlayerWeaponSkinEquipButton_pressed(which_button : TextureButton):
	var index : int = int(which_button.name[0])
	var weapon_sprite = player_vbox.get_node("WeaponSkin" + str(index) + "/NinePatchRect/Sprite")
	$NinePatchRect/SkinSelectionControl/PlayerControl/WeaponSprite.texture = weapon_sprite.texture
	var new_skin : Texture = $NinePatchRect/SkinSelectionControl/PlayerControl/ScrollContainer/VBoxContainer.get_node(
		"WeaponSkin" + str(index) + "/NinePatchRect/Sprite").texture
	if new_skin != null:
		emit_signal("change_player_weapon_skin", new_skin)
		Global.current_player_weapon_skin = new_skin
	# debug, comment out later
	print(index)



func _on_CloseButtonMainUI_pressed():
	visible = false
	get_parent().get_node("CharactersUI").visible = true
