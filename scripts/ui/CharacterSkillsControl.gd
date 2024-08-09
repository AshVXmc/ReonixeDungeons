class_name CharacterSkillsControl extends Control

onready var player_skill_type_option_button = $NinePatchRect/SkillsControl/PlayerControl/SkillTypeOptionButton
onready var glaciela_skill_type_option_button = $NinePatchRect/SkillsControl/GlacielaControl/SkillTypeOptionButton
onready var agnette_skill_type_option_button = $NinePatchRect/SkillsControl/AgnetteControl/SkillTypeOptionButton

onready var player_pskill = $NinePatchRect/SkillsControl/PlayerControl/PrimarySkillScrollContainer
onready var player_pskill_text = $NinePatchRect/SkillsControl/PlayerControl/PrimarySkillScrollContainer/VBoxContainer/RichTextLabel
onready var player_sskill = $NinePatchRect/SkillsControl/PlayerControl/SecondarySkillScrollContainer
onready var player_sskill_text = $NinePatchRect/SkillsControl/PlayerControl/SecondarySkillScrollContainer/VBoxContainer/RichTextLabel
onready var player_tskill = $NinePatchRect/SkillsControl/PlayerControl/TertiarySkillScrollContainer
onready var player_tskill_text = $NinePatchRect/SkillsControl/PlayerControl/TertiarySkillScrollContainer/VBoxContainer/RichTextLabel
onready var player_perkskill = $NinePatchRect/SkillsControl/PlayerControl/PerkSkillScrollContainerControl
onready var player_perkskill_text = $NinePatchRect/SkillsControl/PlayerControl/PerkSkillScrollContainerControl/PerkSkillScrollContainer/VBoxContainer/RichTextLabel
onready var player_perkskill_optionbutton = $NinePatchRect/SkillsControl/PlayerControl/PerkSkillScrollContainerControl/PerkSkillSelectionOption
onready var player_node = get_parent().get_parent().get_parent().get_node("Player")
onready var skills_ui_node = get_parent().get_parent().get_parent().get_node("SkillsUI/Control")

onready var glaciela_pskill = $NinePatchRect/SkillsControl/GlacielaControl/PrimarySkillScrollContainer
onready var glaciela_pskill_text = $NinePatchRect/SkillsControl/GlacielaControl/PrimarySkillScrollContainer/VBoxContainer/RichTextLabel
onready var glaciela_sskill = $NinePatchRect/SkillsControl/GlacielaControl/SecondarySkillScrollContainer
onready var glaciela_sskill_text = $NinePatchRect/SkillsControl/GlacielaControl/SecondarySkillScrollContainer/VBoxContainer/RichTextLabel

onready var glaciela_tskill = $NinePatchRect/SkillsControl/GlacielaControl/TertiarySkillScrollContainer
onready var glaciela_tskill_text = $NinePatchRect/SkillsControl/GlacielaControl/TertiarySkillScrollContainer/VBoxContainer/RichTextLabel

onready var agnette_pskill = $NinePatchRect/SkillsControl/AgnetteControl/PrimarySkillScrollContainer
onready var agnette_pskill_text = $NinePatchRect/SkillsControl/AgnetteControl/PrimarySkillScrollContainer/VBoxContainer/RichTextLabel



signal player_node_update_perk_skill()
signal skillsui_update_perk_skill_ui()

func _ready():

	player_skill_type_option_button.add_item("Primary", 0)
	player_skill_type_option_button.add_item("Secondary", 1)
	player_skill_type_option_button.add_item("Tertiary", 2)
	player_skill_type_option_button.add_item("Perk", 3)
	
	glaciela_skill_type_option_button.add_item("Primary", 0)
	glaciela_skill_type_option_button.add_item("Secondary", 1)
	glaciela_skill_type_option_button.add_item("Tertiary", 2)
	glaciela_skill_type_option_button.add_item("Perk", 3)
	
	agnette_skill_type_option_button.add_item("Primary", 0)
	agnette_skill_type_option_button.add_item("Secondary", 1)
	agnette_skill_type_option_button.add_item("Tertiary", 2)
	agnette_skill_type_option_button.add_item("Perk", 3)
	
	player_perkskill_optionbutton.add_item("Create Sugar Roll", 0)
	player_perkskill_optionbutton.add_item("Chaos Magic", 1)
	connect("player_node_update_perk_skill", player_node, "update_perk_skill")
	connect("skillsui_update_perk_skill_ui", skills_ui_node, "update_perk_skill_ui")
	_on_Player_SkillTypeOptionButton_item_selected(0)
	_on_GlacielaSkillTypeOptionButton_item_selected(0)
	_on_AgnetteSkillTypeOptionButton_item_selected(0)

	update_player_description_text()
	update_glaciela_description_text()
	update_agnette_description_text()
	
	yield(get_tree().create_timer(0.1), "timeout")
	update_perk_skill_selection_ui("Player", Global.player_skills["PerkSkill"])


func update_player_description_text():
	player_pskill_text.bbcode_text = player_pskill_text.bbcode_text.replace(
		"FIRESAW_DUR", str(Global.player_skill_multipliers["FireSawDuration"]))
	player_pskill_text.bbcode_text = player_pskill_text.bbcode_text.replace(
		"FIRESAW_ATK", str(Global.player_skill_multipliers["FireSaw"]))
	player_pskill_text.bbcode_text = player_pskill_text.bbcode_text.replace(
		"FIRESAW_CD", str(Global.player_skill_multipliers["FireSawCD"]))
	player_pskill_text.bbcode_text = player_pskill_text.bbcode_text.replace(
		"FIRESAW_COST", str(Global.player_skill_multipliers["FireSawCost"]))

	player_sskill_text.bbcode_text = player_sskill_text.bbcode_text.replace(
		"FIREFAIRY_DUR", str(Global.player_skill_multipliers["FireFairyDuration"]))
	player_sskill_text.bbcode_text = player_sskill_text.bbcode_text.replace(
		"FIREFAIRY_ATK", str(Global.player_skill_multipliers["FireFairy"]))
	player_sskill_text.bbcode_text = player_sskill_text.bbcode_text.replace(
		"FIREFAIRY_EX_ATK", str(Global.player_skill_multipliers["FireFairyDetonation"]))
	player_sskill_text.bbcode_text = player_sskill_text.bbcode_text.replace(
		"FIREFAIRY_CD", str(Global.player_skill_multipliers["FireFairyCD"]))
	player_sskill_text.bbcode_text = player_sskill_text.bbcode_text.replace(
		"FIREFAIRY_COST", str(Global.player_skill_multipliers["FireFairyCost"]))
	
	player_tskill_text.bbcode_text = player_tskill_text.bbcode_text.replace(
		"FIREBALL_ATK", str(Global.player_skill_multipliers["Fireball"]))
	player_tskill_text.bbcode_text = player_tskill_text.bbcode_text.replace(
		"FIREBALL_CHARGES", str(Global.player_skill_multipliers["FireballCharges"]))
	player_tskill_text.bbcode_text = player_tskill_text.bbcode_text.replace(
		"FIREBALL_CD", str(Global.player_skill_multipliers["FireballCD"]))
	
	player_perkskill_text.bbcode_text = player_perkskill_text.bbcode_text.replace(
		"CREATE_SUGAR_ROLL_CD", str(Global.player_perks["CreateSugarRoll"]["cooldown"]))
	player_perkskill_text.bbcode_text = player_perkskill_text.bbcode_text.replace(
		"CHAOS_MAGIC_TRIGGER_CHANCE", str(Global.player_perks["ChaosMagic"]["triggerchance"]))
	player_perkskill_text.bbcode_text = player_perkskill_text.bbcode_text.replace(
		"CHAOS_MAGIC_CD", str(Global.player_perks["ChaosMagic"]["cooldown"]))
	
func update_glaciela_description_text():
	glaciela_pskill_text.bbcode_text = glaciela_pskill_text.bbcode_text.replace(
		"WQ_ATK", str(Global.glaciela_skill_multipliers["WinterQueen"]))
	glaciela_pskill_text.bbcode_text = glaciela_pskill_text.bbcode_text.replace(
		"WQ_CD", str(Global.glaciela_skill_multipliers["WinterQueenCD"]))
	glaciela_pskill_text.bbcode_text = glaciela_pskill_text.bbcode_text.replace(
		"WQ_COST", str(Global.glaciela_skill_multipliers["WinterQueenCost"]))
	
	glaciela_sskill_text.bbcode_text = glaciela_sskill_text.bbcode_text.replace(
		"ICELANCE_ATK", str(Global.glaciela_skill_multipliers["IceLance"]))
	glaciela_sskill_text.bbcode_text = glaciela_sskill_text.bbcode_text.replace(
		"ICELANCE_FREEZE_GAUGE", str(Global.glaciela_skill_multipliers["IceLanceFreezeGauge"] / 10))
	glaciela_sskill_text.bbcode_text = glaciela_sskill_text.bbcode_text.replace(
		"ICELANCE_DMG_BONUS", str(Global.glaciela_skill_multipliers["IceLanceDamageBonusPerTundraSigil"]))
	glaciela_sskill_text.bbcode_text = glaciela_sskill_text.bbcode_text.replace(
		"ICELANCE_CD", str(Global.glaciela_skill_multipliers["IceLanceCD"]))
	glaciela_sskill_text.bbcode_text = glaciela_sskill_text.bbcode_text.replace(
		"ICELANCE_COST", str(Global.glaciela_skill_multipliers["IceLanceCost"]))
	
	glaciela_tskill_text.bbcode_text = glaciela_tskill_text.bbcode_text.replace(
		"COC_ATK", str(Global.glaciela_skill_multipliers["ConeOfCold"]))
	glaciela_tskill_text.bbcode_text = glaciela_tskill_text.bbcode_text.replace(
		"COC_FREEZE_GAUGE", str(Global.glaciela_skill_multipliers["ConeOfColdFreezeGauge"] / 10))
	glaciela_tskill_text.bbcode_text = glaciela_tskill_text.bbcode_text.replace(
		"COC_CD", str(Global.glaciela_skill_multipliers["ConeOfColdCD"]))
	glaciela_tskill_text.bbcode_text = glaciela_tskill_text.bbcode_text.replace(
		"COC_MOV_SPD_PENALTY", str(Global.glaciela_skill_multipliers["ConeOfColdMovementSpeedPenalty"]))

func update_agnette_description_text():
	agnette_pskill_text.bbcode_text = agnette_pskill_text.bbcode_text.replace(
		"BF_DUR", str(Global.agnette_skill_multipliers["BearFormDuration"]))
	agnette_pskill_text.bbcode_text = agnette_pskill_text.bbcode_text.replace(
		"BF_HP", str(Global.agnette_skill_multipliers["BearFormHealth"]))
	agnette_pskill_text.bbcode_text = agnette_pskill_text.bbcode_text.replace(
		"BF_SPD_PEN", str(Global.agnette_skill_multipliers["BearFormMovementSpeedPenalty"]))
	agnette_pskill_text.bbcode_text = agnette_pskill_text.bbcode_text.replace(
		"BF_CD", str(Global.agnette_skill_multipliers["BearFormCD"]))
	agnette_pskill_text.bbcode_text = agnette_pskill_text.bbcode_text.replace(
		"BF_COST", str(Global.agnette_skill_multipliers["BearFormCost"]))
	
	
# access the update_perk_skill function in player
# access the update_perk_skill_ui function in skillsui
#func print_out_layer():
#	print("Layer is:" + str(get_parent().layer))
func update_perk_skill_selection_ui(character_name : String, perk_name : String):
	pass
	if character_name == "Player":
		Global.player_skills["PerkSkill"] = perk_name
		match perk_name:
			"CreateSugarRoll":
				Global.player_perks["CreateSugarRoll"]["enabled"] = true
				Global.player_perks["ChaosMagic"]["enabled"] = false
				player_perkskill_optionbutton.selected = 0
			"ChaosMagic":
				Global.player_perks["CreateSugarRoll"]["enabled"] = false
				Global.player_perks["ChaosMagic"]["enabled"] = true
				player_perkskill_optionbutton.selected = 1
		emit_signal("player_node_update_perk_skill")
		emit_signal("skillsui_update_perk_skill_ui")

func _on_Player_SkillTypeOptionButton_item_selected(index):
	match index:
		0:
			player_pskill.visible = true
			player_sskill.visible = false
			player_tskill.visible = false
			player_perkskill.visible = false
		1:
			player_pskill.visible = false
			player_sskill.visible = true
			player_tskill.visible = false
			player_perkskill.visible = false
		2:
			player_pskill.visible = false
			player_sskill.visible = false
			player_tskill.visible = true
			player_perkskill.visible = false
		3:
			player_pskill.visible = false
			player_sskill.visible = false
			player_tskill.visible = false
			player_perkskill.visible = true

func _on_CloseButtonMainUI_pressed():
	visible = false
	get_parent().get_node("CharactersUI").visible = true


func _on_Player_PerkSkillSelectionOption_item_selected(index):
	match index:
		0:
			update_perk_skill_selection_ui("Player", "CreateSugarRoll")
		1:
			update_perk_skill_selection_ui("Player", "ChaosMagic")


func _on_GlacielaSkillTypeOptionButton_item_selected(index):
	match index:
		0:
			glaciela_pskill.visible = true
			glaciela_sskill.visible = false
			glaciela_tskill.visible = false
		1:
			glaciela_pskill.visible = false
			glaciela_sskill.visible = true
			glaciela_tskill.visible = false
		2:
			glaciela_pskill.visible = false
			glaciela_sskill.visible = false
			glaciela_tskill.visible = true

func _on_AgnetteSkillTypeOptionButton_item_selected(index):
	match index:
		0:
			agnette_pskill.visible = true
#			agnette_sskill.visible = false
#			agnette_tskill.visible = false
		1:
			agnette_pskill.visible = false
#			agnette_sskill.visible = true
#			agnette_tskill.visible = false
		2:
			agnette_pskill.visible = false
#			agnette_sskill.visible = false
#			agnette_tskill.visible = true
