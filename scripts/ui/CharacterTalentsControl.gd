class_name CharacterTalentsControl extends Control

var player_talents_list : Array = ["CycloneSlashes", "SwiftThrust", "BurningBreath", "InfernalMark"]
onready var player_talent_slots_label = $NinePatchRect/TalentTreeControl/PlayerControl/TalentSlotsCountLabel


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
	$NinePatchRect/TalentTreeControl/PlayerControl/ScrollContainer/VBoxContainer/TalentControl1/PlayerTalentButton/OpalsCostLabel.text = str(Global.player_talents["CycloneSlashes"]["opalscost"])
	$NinePatchRect/TalentTreeControl/PlayerControl/ScrollContainer/VBoxContainer/TalentControl1/PlayerTalentButton/SlotsCostLabel.text = "Slot cost: " + str(Global.player_talents["CycloneSlashes"]["talentslotcost"])
	$NinePatchRect/TalentTreeControl/PlayerControl/ScrollContainer/VBoxContainer/TalentControl2/PlayerTalentButton/OpalsCostLabel.text = str(Global.player_talents["SwiftThrust"]["opalscost"])
	$NinePatchRect/TalentTreeControl/PlayerControl/ScrollContainer/VBoxContainer/TalentControl2/PlayerTalentButton/SlotsCostLabel.text = "Slot cost: " + str(Global.player_talents["SwiftThrust"]["talentslotcost"])
	$NinePatchRect/TalentTreeControl/PlayerControl/ScrollContainer/VBoxContainer/TalentControl3/PlayerTalentButton/OpalsCostLabel.text = str(Global.player_talents["BurningBreath"]["opalscost"])
	$NinePatchRect/TalentTreeControl/PlayerControl/ScrollContainer/VBoxContainer/TalentControl3/PlayerTalentButton/SlotsCostLabel.text = "Slot cost: " + str(Global.player_talents["BurningBreath"]["talentslotcost"])
	$NinePatchRect/TalentTreeControl/PlayerControl/ScrollContainer/VBoxContainer/TalentControl4/PlayerTalentButton/OpalsCostLabel.text = str(Global.player_talents["InfernalMark"]["opalscost"])
	$NinePatchRect/TalentTreeControl/PlayerControl/ScrollContainer/VBoxContainer/TalentControl4/PlayerTalentButton/SlotsCostLabel.text = "Slot cost: " + str(Global.player_talents["InfernalMark"]["talentslotcost"])
	var cumulative_talent_slots_spending : int = 0
	var pt_list_counter = 1
	for pt in player_talents_list:
		if Global.player_talents[pt]["unlocked"]:
			buy_player_talent(pt, pt_list_counter)
			pt_list_counter += 1
			if Global.player_talents[pt]["enabled"]:
				cumulative_talent_slots_spending += Global.player_talents[pt]["talentslotcost"]
	Global.player_talents["TalentSlots"] += cumulative_talent_slots_spending
	player_talent_slots_label.text = str(Global.player_talents["TalentSlots"]) + " / " + str(Global.player_talents["MaxTalentSlots"])


#		if Global.player_talents[pt]["enabled"]:
#			toggle_player_talent(pt, true)
#		else:
#			toggle_player_talent(pt, false)
		


# this function is also used to update bought statuses
func buy_player_talent(talentname : String, order : int):
	Global.player_talents[talentname]["unlocked"] = true
#	Global.player_talents[talentname]["enabled"] = true
	get_node("NinePatchRect/TalentTreeControl/PlayerControl/ScrollContainer/VBoxContainer/TalentControl" + str(order) + "/PlayerTalentButton").disabled = true
	get_node("NinePatchRect/TalentTreeControl/PlayerControl/ScrollContainer/VBoxContainer/TalentControl" + str(order) + "/PlayerTalentButton/ButtonLabel").text = "Bought"
	get_node("NinePatchRect/TalentTreeControl/PlayerControl/ScrollContainer/VBoxContainer/TalentControl" + str(order) + "/PlayerTalentButton/ButtonLabel").add_color_override("font_color", Color(1, 0.84, 0.01, 1))
	get_node("NinePatchRect/TalentTreeControl/PlayerControl/ScrollContainer/VBoxContainer/TalentControl" + str(order) + "/PlayerTalentButton/PlayerCheckButton").visible = true
	get_node("NinePatchRect/TalentTreeControl/PlayerControl/ScrollContainer/VBoxContainer/TalentControl" + str(order) + "/PlayerTalentButton/PlayerCheckButton").pressed = false
	get_node("NinePatchRect/TalentTreeControl/PlayerControl/ScrollContainer/VBoxContainer/TalentControl" + str(order) + "/PlayerTalentButton/OpalsCostLabel").visible = false
#	get_node("NinePatchRect/TalentTreeControl/PlayerControl/ScrollContainer/VBoxContainer/TalentControl" + str(order) + "/PlayerTalentButton/SlotsCostLabel").visible = false

	
func toggle_player_talent(talentname : String, button_pressed : bool, order : int):
	var button = get_node("NinePatchRect/TalentTreeControl/PlayerControl/ScrollContainer/VBoxContainer/TalentControl" + str(order) + "/PlayerTalentButton/PlayerCheckButton")
	if button_pressed:
		Global.player_talents["TalentSlots"] += Global.player_talents[talentname]["talentslotcost"]
		player_talent_slots_label.text = str(Global.player_talents["TalentSlots"]) + " / " + str(Global.player_talents["MaxTalentSlots"])
		Global.player_talents[talentname]["enabled"] = true
	else:
		Global.player_talents["TalentSlots"] -= Global.player_talents[talentname]["talentslotcost"]
		player_talent_slots_label.text = str(Global.player_talents["TalentSlots"]) + " / " + str(Global.player_talents["MaxTalentSlots"])
		Global.player_talents[talentname]["enabled"] = false
		

func buy_glaciela_talent(talentname : String, order : int):
	pass
func toggle_glaciela_talent(talentname : String, button_pressed : bool):
	pass



func _on_PlayerTalentButton1_pressed():
	if !Global.player_talents["CycloneSlashes"]["unlocked"]:
		buy_player_talent("CycloneSlashes", 1)
func _on_PlayerTalentButton2_pressed():
	if !Global.player_talents["SwiftThrust"]["unlocked"]:
		buy_player_talent("SwiftThrust", 2)
func _on_PlayerTalentButton3_pressed():
	if !Global.player_talents["BurningBreath"]["unlocked"]:
		buy_player_talent("BurningBreath", 3)
func _on_PlayerTalentButton4_pressed():
	if !Global.player_talents["InfernalMark"]["unlocked"]:
		buy_player_talent("InfernalMark", 4)

func _on_PlayerCheckButton1_toggled(button_pressed):
	
	toggle_player_talent("CycloneSlashes", button_pressed, 1)

func _on_PlayerCheckButton2_toggled(button_pressed):
	toggle_player_talent("SwiftThrust", button_pressed, 2)
func _on_PlayerCheckButton3_toggled(button_pressed):
	toggle_player_talent("BurningBreath", button_pressed, 3)
func _on_PlayerCheckButton4_toggled(button_pressed):
	toggle_player_talent("InfernalMark", button_pressed, 4)

func _on_CloseButtonMainUI_pressed():
	if Global.player_talents["TalentSlots"] <= Global.player_talents["MaxTalentSlots"]:
		visible = false
		get_parent().get_node("CharactersUI").visible = true
	else:
		$NinePatchRect/TalentTreeControl/PlayerControl/TalentSlotsWarningLabel.visible = true
		yield(get_tree().create_timer(2), "timeout")
		$NinePatchRect/TalentTreeControl/PlayerControl/TalentSlotsWarningLabel.visible = false
