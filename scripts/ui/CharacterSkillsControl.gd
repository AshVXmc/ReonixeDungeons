class_name CharacterSkillsControl extends Control

onready var skill_type_option_button = $NinePatchRect/SkillsControl/PlayerControl/SkillTypeOptionButton
onready var player_pskill = $NinePatchRect/SkillsControl/PlayerControl/PrimarySkillScrollContainer
onready var player_pskill_text = $NinePatchRect/SkillsControl/PlayerControl/PrimarySkillScrollContainer/VBoxContainer/RichTextLabel
onready var player_sskill = $NinePatchRect/SkillsControl/PlayerControl/SecondarySkillScrollContainer
onready var player_sskill_text = $NinePatchRect/SkillsControl/PlayerControl/SecondarySkillScrollContainer/VBoxContainer/RichTextLabel
onready var player_tskill = $NinePatchRect/SkillsControl/PlayerControl/TertiarySkillScrollContainer
onready var player_tskill_text = $NinePatchRect/SkillsControl/PlayerControl/TertiarySkillScrollContainer/VBoxContainer/RichTextLabel
onready var player_perkskill = $NinePatchRect/SkillsControl/PlayerControl/PerkSkillScrollContainerControl
onready var player_perkskill_text = $NinePatchRect/SkillsControl/PlayerControl/PerkSkillScrollContainerControl/PerkSkillScrollContainer/VBoxContainer/RichTextLabel
onready var player_perkskill_options = $NinePatchRect/SkillsControl/PlayerControl/PerkSkillScrollContainerControl/PerkSkillSelectionOption
onready var player_node = get_parent().get_parent().get_parent().get_node("Player")
onready var skills_ui_node = get_parent().get_parent().get_parent().get_node("SkillsUI/Control")

onready var glaciela_pskill
onready var glaciela_sskill
onready var glaciela_tskill

signal player_node_update_perk_skill()
signal skillsui_update_perk_skill_ui()

func _ready():

	skill_type_option_button.add_item("Primary", 0)
	skill_type_option_button.add_item("Secondary", 1)
	skill_type_option_button.add_item("Tertiary", 2)
	skill_type_option_button.add_item("Perk", 3)
	
	player_perkskill_options.add_item("Create Sugar Roll", 0)
	player_perkskill_options.add_item("Chaos Magic", 1)
	
	connect("player_node_update_perk_skill", player_node, "update_perk_skill")
	connect("skillsui_update_perk_skill_ui", skills_ui_node, "update_perk_skill_ui")
	_on_Player_SkillTypeOptionButton_item_selected(0)
	update_description_text()
	yield(get_tree().create_timer(0.1), "timeout")
	update_perk_skill_selection_ui("Player", Global.player_skills["PerkSkill"])
#	print(Global.player_perks["CreateSugarRoll"]["enabled"])
#	print(Global.player_perks["ChaosMagic"]["enabled"])

func update_description_text():
	var firesaw_text = """[color=#ffd703]Flaming Firesaw[/color]
Twin flame blades spin around you for {duration} seconds, dealing [u]{firesawatk}% ATK[/u] as [color=#fd9628]Fire damage[/color] and applies stacks of [color=#fd9628]Burning[/color].
Cooldown: {cooldown} seconds
Mana cost: {cost} mana
	"""
	player_pskill_text.bbcode_text = firesaw_text.format({
		"duration" : str(Global.player_skill_multipliers["FireSawDuration"]),
		"firesawatk": str(Global.player_skill_multipliers["FireSaw"]),
		"cooldown": str(Global.player_skill_multipliers["FireSawCD"]),
		"cost": str(Global.player_skill_multipliers["FireSawCost"])
	}) 
	
	var firefairy_text = """[color=#ffd703]Fire Faerie[/color]
Summon a fire spirit that automatically tracks enemies, dealing [u]{firefairyatk}% ATK[/u] as [color=#fd9628]Fire damage[/color]. Recast the skill to teleport the spirit to your location. The spirit lasts for {duration} seconds.
Cooldown: {cooldown} seconds
Mana cost: {cost} mana
	"""
	player_sskill_text.bbcode_text = firefairy_text.format({
		"duration" : str(Global.player_skill_multipliers["FireFairyDuration"]),
		"firefairyatk": str(Global.player_skill_multipliers["FireFairy"]),
		"cooldown": str(Global.player_skill_multipliers["FireFairyCD"]),
		"cost": str(Global.player_skill_multipliers["FireFairyCost"])
	}) 
	var fireball_text = """[color=#ffd703]Fireball[/color]
Shoot a fiery ball that travels forward in a straight line, dealing [u]{fireballatk}% ATK[/u] as [color=#fd9628]Fire damage[/color]. This skill has {charges} initial charges.
Cooldown: {cooldown} seconds per charge
	""" 
	player_tskill_text.bbcode_text = fireball_text.format({
		"fireballatk": str(Global.player_skill_multipliers["Fireball"]),
		"cooldown": str(Global.player_skill_multipliers["FireballCD"]),
		"charges": str(Global.player_skill_multipliers["FireballCharges"])
	})
	

	var create_sugar_roll_text = """[color=#ffd703]Create Sugar Roll[/color]
Conjure a [color=#bda662]Sugar Roll[/color] at your location. A character can eat the roll, restoring health over time. The roll cannot be eaten if there are enemies nearby, and only one roll may exist in a level.
Cooldown: {cooldown} seconds
	"""
	player_perkskill_text.bbcode_text = create_sugar_roll_text.format({
		"cooldown": str(Global.player_perks["CreateSugarRoll"]["cooldown"])
	})
	


func update_perk_skill_selection_ui(character_name : String, perk_name : String):
	if character_name == "Player":
		
		for key in Global.player_perks.keys():
			if perk_name == key:
				Global.player_perks[key]["enabled"] = true
				Global.player_skills["PerkSkill"] = perk_name
			else:
				Global.player_perks[key]["enabled"] = false
	
#		if perk_name == "CreateSugarRoll":
##			toggle_player_perk("CreateSugarRoll", true)
#			toggle_player_perk("ChaosMagic", false)
#		elif perk_name == "ChaosMagic":
#			toggle_player_perk("CreateSugarRoll", false)
##			toggle_player_perk("ChaosMagic", true)
			
		emit_signal("player_node_update_perk_skill")
		emit_signal("skillsui_update_perk_skill_ui")
#		print("NEW PERK: " + perk_name + str(Global.player_perks[perk_name]["enabled"]))
		


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

func _on_PlayerPerk_CreateSugarRoll_toggled(button_pressed):
	update_perk_skill_selection_ui("Player", "CreateSugarRoll")

func _on_PlayerPerk_ChaosMagic_toggled(button_pressed):
	update_perk_skill_selection_ui("Player", "ChaosMagic")


func _on_CloseButtonMainUI_pressed():
	visible = false
	get_parent().get_node("CharactersUI").visible = true
