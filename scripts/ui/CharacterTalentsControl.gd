class_name CharacterTalentsControl extends Control

var player_talents_list : Array = ["CycloneSlashes", "SwiftThrust", "BurningBreath", "InfernalMark", "SoulSiphon"]
onready var player_talent_slots_label = $NinePatchRect/TalentTreeControl/PlayerControl/TalentSlotsCountLabel
onready var player_talent_desc_text = $NinePatchRect/TalentTreeControl/PlayerControl/ScrollContainer/VBoxContainer/RichTextLabel

var glaciela_talents_list : Array = ["DanceOfRime"]
onready var glaciela_talent_slots_label = $NinePatchRect/TalentTreeControl/GlacielaControl/TalentSlotsCountLabel
onready var glaciela_talent_desc_text = $NinePatchRect/TalentTreeControl/GlacielaControl/ScrollContainer/VBoxContainer/RichTextLabel

func _ready():
	initialize_ui()
	update_player_description_text()
	update_glaciela_description_text()
	
func update_player_description_text():
	player_talent_desc_text.bbcode_text = player_talent_desc_text.bbcode_text.replacen(
		"BURNING_BREATH_COOLDOWN", str(Global.player_talents["BurningBreath"]["cooldown"]))
	player_talent_desc_text.bbcode_text = player_talent_desc_text.bbcode_text.replacen(
		"MARK_DMG_INCREASE", str(Global.player_talents["InfernalMark"]["DamageIncrease"]))
	player_talent_desc_text.bbcode_text = player_talent_desc_text.bbcode_text.replacen(
		"SOUL_SIPHON_DROP_CHANCE", str(Global.player_talents["SoulSiphon"]["dropchance"]))
	player_talent_desc_text.bbcode_text = player_talent_desc_text.bbcode_text.replacen(
		"SOUL_SIPHON_MANA", str(Global.player_talents["SoulSiphon"]["managranted"]))
	

func update_glaciela_description_text():
	pass
	
	
func initialize_ui():
#	visible = true
#	$NinePatchRect/TalentTreeControl/PlayerControl/ScrollContainer/VBoxContainer/TalentControl1/PlayerTalentButton.pressed.connect()
	$NinePatchRect/TalentTreeControl/PlayerControl/ScrollContainer.rect_size.x = 690
	$NinePatchRect/TalentTreeControl/PlayerControl/ScrollContainer.rect_size.y = 375
	$NinePatchRect/TalentTreeControl/PlayerControl/ScrollContainer/VBoxContainer/TalentControl1/PlayerTalentButton/PlayerCheckButton.visible = false
	$NinePatchRect/TalentTreeControl/PlayerControl/ScrollContainer/VBoxContainer/TalentControl2/PlayerTalentButton/PlayerCheckButton.visible = false
	$NinePatchRect/TalentTreeControl/PlayerControl/ScrollContainer/VBoxContainer/TalentControl3/PlayerTalentButton/PlayerCheckButton.visible = false
	$NinePatchRect/TalentTreeControl/PlayerControl/ScrollContainer/VBoxContainer/TalentControl4/PlayerTalentButton/PlayerCheckButton.visible = false
	$NinePatchRect/TalentTreeControl/PlayerControl/ScrollContainer/VBoxContainer/TalentControl5/PlayerTalentButton/PlayerCheckButton.visible = false
	
	$NinePatchRect/TalentTreeControl/GlacielaControl/ScrollContainer/VBoxContainer/TalentControl1/GlacielaTalentButton/GlacielaCheckButton.visible = false
	update_player_talent_tree_ui()
	update_glaciela_talent_tree_ui()
#	get_tree().paused = true


func update_player_talent_tree_ui():
	var cumulative_talent_slots_spending : int = 0
	Global.player_talents["TalentSlots"] = 0
	var pt_list_counter = 1
	var labels_counter = 1
	for pt in player_talents_list:
		get_node("NinePatchRect/TalentTreeControl/PlayerControl/ScrollContainer/VBoxContainer/TalentControl" + str(labels_counter) + "/PlayerTalentButton/OpalsCostLabel").text = str(Global.player_talents[player_talents_list[labels_counter - 1]]["opalscost"])
		get_node("NinePatchRect/TalentTreeControl/PlayerControl/ScrollContainer/VBoxContainer/TalentControl" + str(labels_counter) + "/PlayerTalentButton/SlotsCostLabel").text = "Slot cost: " + str(Global.player_talents[player_talents_list[labels_counter - 1]]["talentslotcost"])
		labels_counter += 1
		if Global.player_talents[pt]["unlocked"]:
			buy_player_talent(pt, pt_list_counter)
			pt_list_counter += 1
			if Global.player_talents[pt]["enabled"]:
				cumulative_talent_slots_spending += Global.player_talents[pt]["talentslotcost"]
				var order = player_talents_list.find(pt) + 1
				get_node("NinePatchRect/TalentTreeControl/PlayerControl/ScrollContainer/VBoxContainer/TalentControl" + str(order) + "/PlayerTalentButton/PlayerCheckButton").pressed = true
	player_talent_slots_label.text = str(Global.player_talents["TalentSlots"]) + " / " + str(Global.player_talents["MaxTalentSlots"])



func toggle_player_talent(talentname : String, button_pressed : bool, order : int):
	if button_pressed:
		Global.player_talents["TalentSlots"] += Global.player_talents[talentname]["talentslotcost"]
		player_talent_slots_label.text = str(Global.player_talents["TalentSlots"]) + " / " + str(Global.player_talents["MaxTalentSlots"])
		Global.player_talents[talentname]["enabled"] = true
	else:
		Global.player_talents["TalentSlots"] -= Global.player_talents[talentname]["talentslotcost"]
		player_talent_slots_label.text = str(Global.player_talents["TalentSlots"]) + " / " + str(Global.player_talents["MaxTalentSlots"])
		Global.player_talents[talentname]["enabled"] = false

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

func update_glaciela_talent_tree_ui():
	var cumulative_talent_slots_spending : int = 0
	Global.glaciela_talents["TalentSlots"] = 0
	var gt_list_counter = 1
	var labels_counter = 1
	for gt in glaciela_talents_list:
		get_node("NinePatchRect/TalentTreeControl/GlacielaControl/ScrollContainer/VBoxContainer/TalentControl" + str(labels_counter) + "/GlacielaTalentButton/OpalsCostLabel").text = str(Global.glaciela_talents[glaciela_talents_list[labels_counter - 1]]["opalscost"])
		get_node("NinePatchRect/TalentTreeControl/GlacielaControl/ScrollContainer/VBoxContainer/TalentControl" + str(labels_counter) + "/GlacielaTalentButton/SlotsCostLabel").text = "Slot cost: " + str(Global.glaciela_talents[glaciela_talents_list[labels_counter - 1]]["talentslotcost"])
		labels_counter += 1
		if Global.glaciela_talents[gt]["unlocked"]:
			buy_glaciela_talent(gt, gt_list_counter)
			gt_list_counter += 1
			if Global.glaciela_talents[gt]["enabled"]:
				cumulative_talent_slots_spending += Global.glaciela_talents[gt]["talentslotcost"]
				var order = glaciela_talents_list.find(gt) + 1
				get_node("NinePatchRect/TalentTreeControl/GlacielaControl/ScrollContainer/VBoxContainer/TalentControl" + str(order) + "/GlacielaTalentButton/GlacielaCheckButton").pressed = true
	glaciela_talent_slots_label.text = str(Global.glaciela_talents["TalentSlots"]) + " / " + str(Global.glaciela_talents["MaxTalentSlots"])


	
func toggle_glaciela_talent(talentname : String, button_pressed : bool, order : int):
	if button_pressed:
		Global.glaciela_talents["TalentSlots"] += Global.glaciela_talents[talentname]["talentslotcost"]
		glaciela_talent_slots_label.text = str(Global.glaciela_talents["TalentSlots"]) + " / " + str(Global.glaciela_talents["MaxTalentSlots"])
		Global.glaciela_talents[talentname]["enabled"] = true
	else:
		Global.glaciela_talents["TalentSlots"] -= Global.glaciela_talents[talentname]["talentslotcost"]
		glaciela_talent_slots_label.text = str(Global.glaciela_talents["TalentSlots"]) + " / " + str(Global.glaciela_talents["MaxTalentSlots"])
		Global.glaciela_talents[talentname]["enabled"] = false
		

func buy_glaciela_talent(talentname : String, order : int):
	Global.glaciela_talents[talentname]["unlocked"] = true
#	Global.player_talents[talentname]["enabled"] = true
	get_node("NinePatchRect/TalentTreeControl/GlacielaControl/ScrollContainer/VBoxContainer/TalentControl" + str(order) + "/GlacielaTalentButton").disabled = true
	get_node("NinePatchRect/TalentTreeControl/GlacielaControl/ScrollContainer/VBoxContainer/TalentControl" + str(order) + "/GlacielaTalentButton/ButtonLabel").text = "Bought"
	get_node("NinePatchRect/TalentTreeControl/GlacielaControl/ScrollContainer/VBoxContainer/TalentControl" + str(order) + "/GlacielaTalentButton/ButtonLabel").add_color_override("font_color", Color(1, 0.84, 0.01, 1))
	get_node("NinePatchRect/TalentTreeControl/GlacielaControl/ScrollContainer/VBoxContainer/TalentControl" + str(order) + "/GlacielaTalentButton/GlacielaCheckButton").visible = true
	get_node("NinePatchRect/TalentTreeControl/GlacielaControl/ScrollContainer/VBoxContainer/TalentControl" + str(order) + "/GlacielaTalentButton/GlacielaCheckButton").pressed = false
	get_node("NinePatchRect/TalentTreeControl/GlacielaControl/ScrollContainer/VBoxContainer/TalentControl" + str(order) + "/GlacielaTalentButton/OpalsCostLabel").visible = false
#	get_node("NinePatchRect/TalentTreeControl/PlayerControl/ScrollContainer/VBoxContainer/TalentControl" + str(order) + "/PlayerTalentButton/SlotsCostLabel").visible = false



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
func _on_PlayerTalentButton5_pressed():
	if !Global.player_talents["SoulSiphon"]["unlocked"]:
		buy_player_talent("SoulSiphon", 5)
	
func _on_PlayerCheckButton1_toggled(button_pressed):
	toggle_player_talent("CycloneSlashes", button_pressed, 1)
func _on_PlayerCheckButton2_toggled(button_pressed):
	toggle_player_talent("SwiftThrust", button_pressed, 2)
func _on_PlayerCheckButton3_toggled(button_pressed):
	toggle_player_talent("BurningBreath", button_pressed, 3)
func _on_PlayerCheckButton4_toggled(button_pressed):
	toggle_player_talent("InfernalMark", button_pressed, 4)
func _on_PlayerCheckButton5_toggled(button_pressed):
	toggle_player_talent("SoulSiphon", button_pressed, 5)


func _on_GlacielaTalentButton1_pressed():
	if !Global.glaciela_talents["DanceOfRime"]["unlocked"]:
		buy_glaciela_talent("DanceOfRime", 1)

func _on_GlacielaCheckButton1_toggled(button_pressed):
	toggle_glaciela_talent("DanceOfRime", button_pressed, 1)



func _on_CloseButtonMainUI_pressed():
	if $NinePatchRect/TalentTreeControl/PlayerControl.visible:
		if Global.player_talents["TalentSlots"] <= Global.player_talents["MaxTalentSlots"]:
			visible = false
			get_parent().get_node("CharactersUI").visible = true
		else:
			$NinePatchRect/TalentTreeControl/PlayerControl/TalentSlotsWarningLabel.visible = true
			yield(get_tree().create_timer(2), "timeout")
			$NinePatchRect/TalentTreeControl/PlayerControl/TalentSlotsWarningLabel.visible = false
	elif $NinePatchRect/TalentTreeControl/GlacielaControl.visible:
		if Global.glaciela_talents["TalentSlots"] <= Global.glaciela_talents["MaxTalentSlots"]:
			visible = false
			get_parent().get_node("CharactersUI").visible = true
		else:
			$NinePatchRect/TalentTreeControl/GlacielaControl/TalentSlotsWarningLabel.visible = true
			yield(get_tree().create_timer(2), "timeout")
			$NinePatchRect/TalentTreeControl/GlacielaControl/TalentSlotsWarningLabel.visible = false







