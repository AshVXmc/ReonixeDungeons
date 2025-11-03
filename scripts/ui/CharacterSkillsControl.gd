class_name CharacterSkillsControl extends Control

onready var player_skill_type_option_button = $NinePatchRect/SkillsControl/PlayerControl/SkillTypeOptionButton
onready var glaciela_skill_type_option_button = $NinePatchRect/SkillsControl/GlacielaControl/SkillTypeOptionButton
onready var agnette_skill_type_option_button = $NinePatchRect/SkillsControl/AgnetteControl/SkillTypeOptionButton

onready var player_moveset_text_label = $NinePatchRect/SkillsControl/PlayerControl/MovesetsScrollContainer/VBoxContainer/RichTextLabel
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
onready var agnette_sskill = $NinePatchRect/SkillsControl/AgnetteControl/SecondarySkillScrollContainer
onready var agnette_sskill_text = $NinePatchRect/SkillsControl/AgnetteControl/SecondarySkillScrollContainer/VBoxContainer/RichTextLabel
onready var agnette_tskill = $NinePatchRect/SkillsControl/AgnetteControl/TertiarySkillScrollContainer
onready var agnette_tskill_text = $NinePatchRect/SkillsControl/AgnetteControl/TertiarySkillScrollContainer/VBoxContainer/RichTextLabel

var skills_info_dict : Dictionary
var movesets_info_dict : Dictionary

signal player_node_update_perk_skill()
signal skillsui_update_perk_skill_ui()

func _ready():
	
	player_skill_type_option_button.add_item("Movesets", 0)
	player_skill_type_option_button.add_item("Primary", 1)
	player_skill_type_option_button.add_item("Secondary", 2)
	player_skill_type_option_button.add_item("Tertiary", 3)
	player_skill_type_option_button.add_item("Perk", 4)
	
	glaciela_skill_type_option_button.add_item("Movesets", 0)
	glaciela_skill_type_option_button.add_item("Primary", 1)
	glaciela_skill_type_option_button.add_item("Secondary", 2)
	glaciela_skill_type_option_button.add_item("Tertiary", 3)
	glaciela_skill_type_option_button.add_item("Perk", 4)
	
	agnette_skill_type_option_button.add_item("Movesets", 0)
	agnette_skill_type_option_button.add_item("Primary", 1)
	agnette_skill_type_option_button.add_item("Secondary", 2)
	agnette_skill_type_option_button.add_item("Tertiary", 3)
	agnette_skill_type_option_button.add_item("Perk", 4)
	
	player_perkskill_optionbutton.add_item("Create Sugar Roll", 0)
	player_perkskill_optionbutton.add_item("Chaos Magic", 1)
	connect("player_node_update_perk_skill", player_node, "update_perk_skill")
	connect("skillsui_update_perk_skill_ui", skills_ui_node, "update_perk_skill_ui")
	_on_Player_SkillTypeOptionButton_item_selected(0)
	_on_GlacielaSkillTypeOptionButton_item_selected(0)
	_on_AgnetteSkillTypeOptionButton_item_selected(0)
	
	var skills_info = File.new()
	skills_info.open("res://scripts/jsondata/SkillsInfo.json", File.READ)
	skills_info_dict = parse_json(skills_info.get_as_text())

	var movesets_info = File.new()
	movesets_info.open("res://scripts/jsondata/MovesetsInfo.json", File.READ)
	movesets_info_dict = parse_json(movesets_info.get_as_text())
	
	update_player_description_text()
	update_glaciela_description_text()
	update_agnette_description_text()

	yield(get_tree().create_timer(0.1), "timeout")
	update_perk_skill_selection_ui("Player", Global.player_skills["PerkSkill"])


func update_player_description_text():
	# movesets
	var player_moveset_text : String 
	var basic_attack : String = movesets_info_dict["Player"]["BasicAttack"]["Header"] + "\n" + movesets_info_dict["Player"]["BasicAttack"]["Description"]
	var aerial_basic_attack : String = movesets_info_dict["Player"]["AerialBasicAttack"]["Header"] + "\n" + movesets_info_dict["Player"]["AerialBasicAttack"]["Description"]
	var charged_attack : String = movesets_info_dict["Player"]["ChargedAttack"]["Header"] + "\n" + movesets_info_dict["Player"]["ChargedAttack"]["Description"]
	var aerial_charged_attack : String = movesets_info_dict["Player"]["AerialChargedAttack"]["Header"] + "\n" + movesets_info_dict["Player"]["AerialChargedAttack"]["Description"]
	var knockup_charged_attack : String = movesets_info_dict["Player"]["KnockUpChargedAttack"]["Header"] + "\n" + movesets_info_dict["Player"]["KnockUpChargedAttack"]["Description"]
	var ex_charged_attack : String = movesets_info_dict["Player"]["EXChargedAttack"]["Header"] + "\n" + movesets_info_dict["Player"]["EXChargedAttack"]["Description"]
	var dash_counter_attack : String = movesets_info_dict["Player"]["DashCounterAttack"]["Header"] + "\n" + movesets_info_dict["Player"]["DashCounterAttack"]["Description"]
	player_moveset_text = movesets_info_dict["Player"]["Header"] + "\n\n" + basic_attack + "\n\n" + aerial_basic_attack + "\n\n" + charged_attack + "\n\n" + aerial_charged_attack + "\n\n" + knockup_charged_attack + "\n\n" + ex_charged_attack + "\n\n" + dash_counter_attack
	player_moveset_text_label.bbcode_text = player_moveset_text

	# movesets from talent
	
	
	# primary skill
	var pskill_header : String = skills_info_dict["Player"]["PrimarySkill"]["Header"]
	var pskill_desc : String = skills_info_dict["Player"]["PrimarySkill"]["Description"]
	var pskill_cd : String = skills_info_dict["Player"]["PrimarySkill"]["Cooldown"]
	var pskill_manacost : String = skills_info_dict["Player"]["PrimarySkill"]["ManaCost"]
	pskill_desc = pskill_desc.replace("FIRESAW_DUR", str(Global.player_skill_multipliers["FireSawDuration"]))
	pskill_desc = pskill_desc.replace("FIRESAW_ATK", str(Global.player_skill_multipliers["FireSaw"]))
	pskill_cd = pskill_cd.replace("FIRESAW_CD", str(Global.player_skill_multipliers["FireSawCD"]))
	pskill_manacost = pskill_manacost.replace("FIRESAW_COST", str(Global.player_skill_multipliers["FireSawCost"]))
	
	player_pskill_text.bbcode_text = pskill_header + "\n\n" + pskill_desc + "\n\n" + pskill_cd + "\n" + pskill_manacost
	
	# secondary skill
	var sskill_header : String = skills_info_dict["Player"]["SecondarySkill"]["Header"]
	var sskill_desc : String = skills_info_dict["Player"]["SecondarySkill"]["Description"]
	var sskill_desc_2 : String = skills_info_dict["Player"]["SecondarySkill"]["Description2"]
	var sskill_desc_3 : String = skills_info_dict["Player"]["SecondarySkill"]["Description3"]
	var sskill_desc_4 : String = skills_info_dict["Player"]["SecondarySkill"]["Description4"]
	var sskill_cd : String = skills_info_dict["Player"]["SecondarySkill"]["Cooldown"]
	var sskill_manacost : String = skills_info_dict["Player"]["SecondarySkill"]["ManaCost"]

	sskill_desc = sskill_desc.replace("FIREFAIRY_DUR", str(Global.player_skill_multipliers["FireFairyDuration"]))
	sskill_desc = sskill_desc.replace("FIREFAIRY_ATK", str(Global.player_skill_multipliers["FireFairy"]))
	sskill_desc_3 = sskill_desc_3.replace("FIREFAIRY_JOINT_ATK", str(Global.player_skill_multipliers["FireFairyJointAttackSlash"]))
	sskill_desc_4 = sskill_desc_4.replace("FIREFAIRY_EX_ATK", str(Global.player_skill_multipliers["FireFairyDetonation"]))
	sskill_desc_4 = sskill_desc_4.replace("MAX_JOINT_ATTACK_POINTS", str(Global.player_skill_multipliers["FireFairyJointAttackPoints"]))
	# TODO

	
	sskill_cd = sskill_cd.replace("FIREFAIRY_CD", str(Global.player_skill_multipliers["FireFairyCD"]))
	sskill_manacost = sskill_manacost.replace("FIREFAIRY_COST", str(Global.player_skill_multipliers["FireFairyCost"]))

	player_sskill_text.bbcode_text = sskill_header + "\n\n" + sskill_desc + "\n\n" + sskill_desc_2 + "\n\n" + sskill_desc_3 + "\n\n" + sskill_desc_4 + "\n\n" + sskill_cd + "\n" + sskill_manacost
	
	
	# tertiary skill
	var tskill_header : String = skills_info_dict["Player"]["TertiarySkill"]["Header"]
	var tskill_desc : String = skills_info_dict["Player"]["TertiarySkill"]["Description"]
	var tskill_cd : String = skills_info_dict["Player"]["TertiarySkill"]["Cooldown"]
	tskill_desc = tskill_desc.replace("FIREBALL_ATK", str(Global.player_skill_multipliers["Fireball"]))
	tskill_desc = tskill_desc.replace("FIREBALL_CHARGES", str(Global.player_skill_multipliers["FireballMaxCharges"]))
	tskill_cd = tskill_cd.replace("FIREBALL_CD", str(Global.player_skill_multipliers["FireballCD"]))
	player_tskill_text.bbcode_text = tskill_header + "\n\n" + tskill_desc + "\n\n" + tskill_cd + "\n"

	
	player_perkskill_text.bbcode_text = player_perkskill_text.bbcode_text.replace(
		"CREATE_SUGAR_ROLL_CD", str(Global.player_perks["CreateSugarRoll"]["cooldown"]))
	player_perkskill_text.bbcode_text = player_perkskill_text.bbcode_text.replace(
		"CHAOS_MAGIC_TRIGGER_CHANCE", str(Global.player_perks["ChaosMagic"]["triggerchance"]))
	player_perkskill_text.bbcode_text = player_perkskill_text.bbcode_text.replace(
		"CHAOS_MAGIC_CD", str(Global.player_perks["ChaosMagic"]["cooldown"]))
	
func update_glaciela_description_text():
	var pskill_header : String = skills_info_dict["Glaciela"]["PrimarySkill"]["Header"]
	var pskill_desc : String = skills_info_dict["Glaciela"]["PrimarySkill"]["Description"]
	var pskill_cd : String = skills_info_dict["Glaciela"]["PrimarySkill"]["Cooldown"]
	var pskill_manacost : String = skills_info_dict["Glaciela"]["PrimarySkill"]["ManaCost"]
	pskill_desc = pskill_desc.replace("WQ_DUR", str(Global.glaciela_skill_multipliers["WinterQueenDuration"]))
	pskill_desc = pskill_desc.replace("WQ_ATK", str(Global.glaciela_skill_multipliers["WinterQueen"]))
	pskill_cd = pskill_cd.replace("WQ_CD", str(Global.glaciela_skill_multipliers["WinterQueenCD"]))
	pskill_manacost = pskill_manacost.replace("WQ_COST", str(Global.glaciela_skill_multipliers["WinterQueenCost"]))
	
	glaciela_pskill_text.bbcode_text = pskill_header + "\n\n" + pskill_desc + "\n\n" + pskill_cd + "\n" + pskill_manacost
	
	var sskill_header : String = skills_info_dict["Glaciela"]["SecondarySkill"]["Header"]
	var sskill_desc : String = skills_info_dict["Glaciela"]["SecondarySkill"]["Description"]
	var sskill_desc_2 : String = skills_info_dict["Glaciela"]["SecondarySkill"]["Description2"]
	var sskill_cd : String = skills_info_dict["Glaciela"]["SecondarySkill"]["Cooldown"]
	var sskill_manacost : String = skills_info_dict["Glaciela"]["SecondarySkill"]["ManaCost"]
	
	sskill_desc = sskill_desc.replace("ICELANCE_ATK", str(Global.glaciela_skill_multipliers["IceLance"]))
	sskill_desc = sskill_desc.replace("ICELANCE_FREEZE_GAUGE", str(Global.glaciela_skill_multipliers["IceLanceFreezeGauge"]))
	sskill_desc_2 = sskill_desc_2.replace("ICELANCE_DMG_BONUS", str(Global.glaciela_skill_multipliers["IceLanceDamageBonusPerTundraSigil"]))
	sskill_cd = sskill_cd.replace("ICELANCE_CD", str(Global.glaciela_skill_multipliers["IceLanceCD"]))
	
	glaciela_sskill_text.bbcode_text = sskill_header + "\n\n" + sskill_desc + "\n\n" + sskill_desc_2 + "\n\n" + sskill_cd + "\n" + sskill_manacost

	var tskill_header : String = skills_info_dict["Glaciela"]["TertiarySkill"]["Header"]
	var tskill_desc : String = skills_info_dict["Glaciela"]["TertiarySkill"]["Description"]
	var tskill_desc_2 : String = skills_info_dict["Glaciela"]["TertiarySkill"]["Description2"]
	var tskill_cd : String = skills_info_dict["Glaciela"]["TertiarySkill"]["Cooldown"]

	glaciela_tskill_text.bbcode_text = tskill_header + "\n\n" + tskill_desc + "\n\n" + tskill_desc_2 + "\n\n" + tskill_cd + "\n" 

	

func update_agnette_description_text():
	var pskill_header : String = skills_info_dict["Agnette"]["PrimarySkill"]["Header"]
	var pskill_header_2 : String = skills_info_dict["Agnette"]["PrimarySkill"]["Header2"]
	var pskill_desc : String = skills_info_dict["Agnette"]["PrimarySkill"]["Description"]
	var pskill_desc_2 : String = skills_info_dict["Agnette"]["PrimarySkill"]["Description2"]
	var pskill_cd : String = skills_info_dict["Agnette"]["PrimarySkill"]["Cooldown"]
	var pskill_manacost : String = skills_info_dict["Agnette"]["PrimarySkill"]["ManaCost"]
	pskill_desc = pskill_desc.replace("BF_SPD_PEN", str(Global.agnette_skill_multipliers["BearFormMovementSpeedPenalty"]))
	pskill_desc = pskill_desc.replace("BF_ATK", str(Global.agnette_skill_multipliers["BearFormAttack1"]))
	pskill_desc = pskill_desc.replace("BF_CATK", str(Global.agnette_skill_multipliers["BearFormShockwave"]))
	pskill_cd = pskill_cd.replace("BF_CD", str(Global.agnette_skill_multipliers["BearFormCD"]))
	pskill_cd = pskill_cd.replace("BF_COST", str(Global.agnette_skill_multipliers["BearFormCost"]))

	
	
#	agnette_pskill_text.bbcode_text = agnette_pskill_text.bbcode_text.replace(
#		"BF_DUR", str(Global.agnette_skill_multipliers["BearFormDuration"]))
#	agnette_pskill_text.bbcode_text = agnette_pskill_text.bbcode_text.replace(
#		"BF_HP", str(Global.agnette_skill_multipliers["BearFormHealth"]))
#	agnette_pskill_text.bbcode_text = agnette_pskill_text.bbcode_text.replace(
#		"BF_SPD_PEN", str(Global.agnette_skill_multipliers["BearFormMovementSpeedPenalty"]))
#	agnette_pskill_text.bbcode_text = agnette_pskill_text.bbcode_text.replace(
#		"BF_CD", str(Global.agnette_skill_multipliers["BearFormCD"]))
#	agnette_pskill_text.bbcode_text = agnette_pskill_text.bbcode_text.replace(
#		"BF_COST", str(Global.agnette_skill_multipliers["BearFormCost"]))
#	agnette_pskill_text.bbcode_text = agnette_pskill_text.bbcode_text.replace(
#		"BF_ATK", str(Global.agnette_skill_multipliers["BearFormAttack1"]))
#	agnette_pskill_text.bbcode_text = agnette_pskill_text.bbcode_text.replace(
#		"BF_CATK", str(Global.agnette_skill_multipliers["BearFormShockwave"]))
#
#	agnette_tskill_text.bbcode_text = agnette_tskill_text.bbcode_text.replace(
#		"SG_DMG", str(Global.agnette_skill_multipliers["SpikeGrowth"]))
#	agnette_tskill_text.bbcode_text = agnette_tskill_text.bbcode_text.replace(
#		"SG_CHARGES", str(Global.agnette_skill_multipliers["SpikeGrowthCharges"]))
#	agnette_tskill_text.bbcode_text = agnette_tskill_text.bbcode_text.replace(
#		"SG_CD", str(Global.agnette_skill_multipliers["SpikeGrowthCD"]))
#	agnette_tskill_text.bbcode_text = agnette_tskill_text.bbcode_text.replace(
#		"SG_DUR", str(Global.agnette_skill_multipliers["SpikeGrowthDuration"]))
#
#	agnette_sskill_text.bbcode_text = agnette_sskill_text.bbcode_text.replace(
#		"RF_DUR", str(Global.agnette_skill_multipliers["RavenFormDuration"]))
#	agnette_sskill_text.bbcode_text = agnette_sskill_text.bbcode_text.replace(
#		"RF_HP", str(Global.agnette_skill_multipliers["RavenFormHealth"]))
#	agnette_sskill_text.bbcode_text = agnette_sskill_text.bbcode_text.replace(
#		"RF_CD", str(Global.agnette_skill_multipliers["RavenFormCD"]))
#	agnette_sskill_text.bbcode_text = agnette_sskill_text.bbcode_text.replace(
#		"RF_COST", str(Global.agnette_skill_multipliers["RavenFormCost"]))
#	agnette_sskill_text.bbcode_text = agnette_sskill_text.bbcode_text.replace(
#		"UI_UP", "[color=#ffd073]" + InputMap.get_action_list("ui_up")[0].as_text() + "[/color]")
#	agnette_sskill_text.bbcode_text = agnette_sskill_text.bbcode_text.replace(
#		"UI_DOWN", "[color=#ffd073]" + InputMap.get_action_list("ui_down")[0].as_text() + "[/color]")
#	agnette_sskill_text.bbcode_text = agnette_sskill_text.bbcode_text.replace(
#		"UI_JUMP", "[color=#ffd073]" + InputMap.get_action_list("jump")[0].as_text() + "[/color]")
#	agnette_sskill_text.bbcode_text = agnette_sskill_text.bbcode_text.replace(
#		"RF_PECK", str(Global.agnette_skill_multipliers["RavenFormPeckAttack"]))
#	agnette_sskill_text.bbcode_text = agnette_sskill_text.bbcode_text.replace(
#		"RF_ROCK", str(Global.agnette_skill_multipliers["RavenFormBombardmentAttack"]))
#
	
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
		1:
			player_pskill.visible = true
			player_sskill.visible = false
			player_tskill.visible = false
			player_perkskill.visible = false
		2:
			player_pskill.visible = false
			player_sskill.visible = true
			player_tskill.visible = false
			player_perkskill.visible = false
		3:
			player_pskill.visible = false
			player_sskill.visible = false
			player_tskill.visible = true
			player_perkskill.visible = false
		4:
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
		1:
			glaciela_pskill.visible = true
			glaciela_sskill.visible = false
			glaciela_tskill.visible = false
		2:
			glaciela_pskill.visible = false
			glaciela_sskill.visible = true
			glaciela_tskill.visible = false
		3:
			glaciela_pskill.visible = false
			glaciela_sskill.visible = false
			glaciela_tskill.visible = true

func _on_AgnetteSkillTypeOptionButton_item_selected(index):
	match index:
		1:
			agnette_pskill.visible = true
			agnette_sskill.visible = false
			agnette_tskill.visible = false
		2:
			agnette_pskill.visible = false
			agnette_sskill.visible = true
			agnette_tskill.visible = false
		3:
			agnette_pskill.visible = false
			agnette_sskill.visible = false
			agnette_tskill.visible = true
