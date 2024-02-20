class_name CharacterTalentsControl extends Control

func _ready():
	initialize_ui()

func initialize_ui():
#	visible = true
#	$NinePatchRect/TalentTreeControl/PlayerControl/ScrollContainer/VBoxContainer/TalentControl1/PlayerTalentButton.pressed.connect()
	$NinePatchRect/TalentTreeControl/PlayerControl/ScrollContainer.rect_size.x = 690
	$NinePatchRect/TalentTreeControl/PlayerControl/ScrollContainer.rect_size.y = 375
	$NinePatchRect/TalentTreeControl/PlayerControl/ScrollContainer/VBoxContainer/TalentControl1/PlayerTalentButton/PlayerCheckButton.visible = false
	$NinePatchRect/TalentTreeControl/PlayerControl/ScrollContainer/VBoxContainer/TalentControl2/PlayerTalentButton/PlayerCheckButton.visible = false
	$NinePatchRect/TalentTreeControl/PlayerControl/ScrollContainer/VBoxContainer/TalentControl3/PlayerTalentButton/PlayerCheckButton.visible = false
	$NinePatchRect/TalentTreeControl/PlayerControl/ScrollContainer/VBoxContainer/TalentControl4/PlayerTalentButton/PlayerCheckButton.visible = false
	
	update_talent_tree_ui()
#	get_tree().paused = true

func update_talent_tree_ui():
	pass

func _on_CloseButtonMainUI_pressed():
	visible = false
	get_parent().get_node("CharactersUI").visible = true
	print("dddddd")
#	get_tree().paused = false

func buy_player_talent(talentname : String, order : int):
	if !Global.player_talents[talentname]["unlocked"]:
		Global.player_talents[talentname]["unlocked"] = true
		Global.player_talents[talentname]["enabled"] = true
		get_node("NinePatchRect/TalentTreeControl/PlayerControl/ScrollContainer/VBoxContainer/TalentControl" + str(order) + "/PlayerTalentButton").disabled = true
		get_node("NinePatchRect/TalentTreeControl/PlayerControl/ScrollContainer/VBoxContainer/TalentControl" + str(order) + "/PlayerTalentButton/ButtonLabel").text = "Bought"
		get_node("NinePatchRect/TalentTreeControl/PlayerControl/ScrollContainer/VBoxContainer/TalentControl" + str(order) + "/PlayerTalentButton/ButtonLabel").add_color_override("font_color", Color(1, 0.84, 0.01, 1))
		get_node("NinePatchRect/TalentTreeControl/PlayerControl/ScrollContainer/VBoxContainer/TalentControl" + str(order) + "/PlayerTalentButton/PlayerCheckButton").visible = true
		get_node("NinePatchRect/TalentTreeControl/PlayerControl/ScrollContainer/VBoxContainer/TalentControl" + str(order) + "/PlayerTalentButton/PlayerCheckButton").pressed = true

func toggle_player_talent(talentname : String, button_pressed : bool):
	if button_pressed:
		Global.player_talents[talentname]["enabled"] = true
	else:
		Global.player_talents[talentname]["enabled"] = false



func _on_PlayerTalentButton1_pressed():
	buy_player_talent("CycloneSlashes", 1)
func _on_PlayerTalentButton2_pressed():
	buy_player_talent("SwiftThrust", 2)
func _on_PlayerTalentButton3_pressed():
	buy_player_talent("BreathOfFlame", 3)
func _on_PlayerTalentButton4_pressed():
	buy_player_talent("InfernalMark", 4)

func _on_PlayerCheckButton1_toggled(button_pressed):
	toggle_player_talent("CycloneSlashes", button_pressed)
func _on_PlayerCheckButton2_toggled(button_pressed):
	toggle_player_talent("SwiftThrust", button_pressed)
func _on_PlayerCheckButton3_toggled(button_pressed):
	buy_player_talent("BreathOfFlame", button_pressed)
func _on_PlayerCheckButton4_toggled(button_pressed):
	buy_player_talent("InfernalMark", button_pressed)
