class_name Wardrobe extends Node2D

signal change_skin(skin_name)
onready var PLAYER_SPRITE_DISPLAY : Sprite = $WardrobeUI/Control/NinePatchRect/ScrollContainer/VBoxContainer/PlayerControl/PlayerSprite
onready var PLAYER : Area2D = get_parent().get_node("Player").get_node("Area2D")

func _ready():
	connect("change_skin", get_parent().get_node("Player"), "change_skin")
	
func _process(delta):
	if $Area2D.overlaps_area(PLAYER):
		$Label.visible = true
		$Keybind.visible = true
	else:
		$Label.visible = false
		$Keybind.visible = false
	if $Area2D.overlaps_area(PLAYER) and Input.is_action_just_pressed("ui_use"):
		toggle_wardrobe_ui()

func toggle_wardrobe_ui():
	if !$WardrobeUI/Control.visible:
		get_tree().paused = true
		$WardrobeUI.layer = 7
		$WardrobeUI/Control.visible = true
		PLAYER.get_parent().is_shopping = true
	else:
		get_tree().paused = false
		$WardrobeUI.layer = 7
		$WardrobeUI/Control.visible = false
		PLAYER.get_parent().is_shopping = false

func update_sprite_display(character_name : String, skin_name : String):
	match character_name:
		"Player":
			match skin_name:
				"DefaultSkin":
					PLAYER_SPRITE_DISPLAY.texture = $WardrobeUI/Control/NinePatchRect/ScrollContainer/VBoxContainer/PlayerControl/DefaultSkin.texture
				"WhiteMage":
					PLAYER_SPRITE_DISPLAY.texture = $WardrobeUI/Control/NinePatchRect/ScrollContainer/VBoxContainer/PlayerControl/WhiteMage.texture
				"CyberNinja":
					PLAYER_SPRITE_DISPLAY.texture = $WardrobeUI/Control/NinePatchRect/ScrollContainer/VBoxContainer/PlayerControl/CyberNinja.texture
		"Glaciela":
			pass
		"Agnette":
			pass

func _on_CloseButtonMainUI_pressed():
	toggle_wardrobe_ui()

func _on_DefaultSkinSelectButton_pressed():
	emit_signal("change_skin", "DEFAULT_SKIN")
	update_sprite_display("Player", "DefaultSkin")
func _on_WhiteMageSelectButton_pressed():
	emit_signal("change_skin", "WHITE_MAGE_SKIN")
	update_sprite_display("Player", "WhiteMage")
func _on_CyberNinjaSelectButton_pressed():
	emit_signal("change_skin", "CYBER_NINJA_SKIN")
	update_sprite_display("Player", "CyberNinja")


