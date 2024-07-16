class_name CharacterTalentsControl extends Control

var player_talents_list : Array = ["CycloneSlashes", "SwiftThrust", "BurningBreath", "InfernalMark", "SoulSiphon"]
onready var player_talent_slots_label = $NinePatchRect/TalentTreeControl/PlayerControl/TalentSlotsCountLabel
onready var player_talent_desc_text = $NinePatchRect/TalentTreeControl/PlayerControl/ScrollContainer/VBoxContainer/RichTextLabel

var glaciela_talents_list : Array = ["DanceOfRime", "FrigidHailstorm"]
onready var glaciela_talent_slots_label = $NinePatchRect/TalentTreeControl/GlacielaControl/TalentSlotsCountLabel
onready var glaciela_talent_desc_text = $NinePatchRect/TalentTreeControl/GlacielaControl/ScrollContainer/VBoxContainer/RichTextLabel

func _ready():
	initialize_ui()
	update_player_description_text()
	update_glaciela_description_text()
	
func update_player_description_text():
	var talent1 = """[color=#ffd703]Cyclone Slashes[/color]
Doing a charged attack after Basic Attack SEQ 2 unleashes a flurry of windblades to deal multiple instances of Physical DMG.
([color=#ffd703]ATK[/color], [color=#ffd703]ATK[/color], Hold [color=#ffd703]ATK[/color])
"""
	var talent2 = """

[color=#ffd703]Swift Thrust[/color]
Airborne charged attacks can now be chained up to 2 times.
	"""
	var talent3 = """
	
[color=#ffd703]Burning Breath[/color]
When you take damage, you unleash a fiery rebuke, [color=#fd9628]Burning[/color] enemies in a cone-shaped area.
Cooldown: {cooldown} seconds
	"""
	var talent4 = """
[color=#ffd703]Infernal Mark[/color]
Enemies marked with the Sulphuric Sigil take {dmgincrease}% more damage. The Fire Fairy can apply the sigil to enemies.
	"""
	var talent5 = """
	
[color=#ffd703]Soul Siphon[/color]
Upon death, enemies have a {chance}% chance to drop a [color=#540d17]Soul Orb[/color]. The Player and him alone can pick up these orbs to restore {mana} Mana.
	"""
	
	player_talent_desc_text.bbcode_text = (
		talent1 + talent2 + talent3.format({
			"cooldown": str(Global.player_talents["BurningBreath"]["cooldown"])
		}) + talent4.format({
			"dmgincrease": str(Global.player_talents["InfernalMark"]["DamageIncrease"])
		}) + talent5.format({
			"chance": str(Global.player_talents["SoulSiphon"]["dropchance"]),
			"mana": str(Global.player_talents["SoulSiphon"]["managranted"])
		})
	)  

func update_glaciela_description_text():
	var talent1 = """[color=#ffd703]Dance of Rime[/color]
Doing the following attack sequence ([color=#ffd703]ATK[/color], [color=#ffd703]ATK[/color], [color=#ffd703]ATK[/color], pause until a [color=yellow]yellow star[/color] appears and press [color=#ffd703]ATK[/color]) unleashes a spear dance that deals multiple instances of [color=#7df0ff]Ice[/color] DMG and knocks enemies back.
"""
	glaciela_talent_desc_text.bbcode_text = (
		talent1
	)
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
	update_talent_tree_ui()
#	get_tree().paused = true


func update_talent_tree_ui():
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




func _on_CloseButtonMainUI_pressed():
	if Global.player_talents["TalentSlots"] <= Global.player_talents["MaxTalentSlots"]:
		visible = false
		get_parent().get_node("CharactersUI").visible = true
	else:
		$NinePatchRect/TalentTreeControl/PlayerControl/TalentSlotsWarningLabel.visible = true
		yield(get_tree().create_timer(2), "timeout")
		$NinePatchRect/TalentTreeControl/PlayerControl/TalentSlotsWarningLabel.visible = false





