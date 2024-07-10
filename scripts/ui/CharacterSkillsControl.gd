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
onready var player_perkskill_optionbutton = $NinePatchRect/SkillsControl/PlayerControl/PerkSkillScrollContainerControl/PerkSkillSelectionOption
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
	
	player_perkskill_optionbutton.add_item("Create Sugar Roll", 0)
	player_perkskill_optionbutton.add_item("Chaos Magic", 1)
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
	

	var createsugarroll_text = """[color=#ffd703]Create Sugar Roll[/color]
Conjure a [color=#bda662]Sugar Roll[/color] at your location. A character can eat the roll, restoring health over time. The roll cannot be eaten if there are enemies nearby, and only one roll may exist in a level.
Cooldown: {cooldown} seconds
	"""
	
	var chaosmagic_text = """
[color=#ffd703]Chaos Magic[/color]
Upon casting, you produce one of the following effects at random. Casting your Primary, Secondary or Tertiary Skills also have a {triggerchance}% chance of triggering this skill.
 [color=#cc0001]1[/color]:
A gust of wind propels you upward, knocking enemies away.
 [color=#fb940b]2[/color]:
A small flame appears at your location, exploding after a short delay, dealing [color=#fd9628]Fire[/color] damage. You also take damage from the explosion.
 [color=#ffff01]3[/color]:
You temporarily get frozen in place. While frozen, you are immobile and you cannot attack.
 [color=#01cc00]4[/color]:
You gain a shield that absorbs damage, based on your party's average Max Health.
 [color=#03c0c6]5[/color]:
You shoot out seven magical missiles that home into enemies, dealing [color=#7df0ff]Ice[/color] damage.
 [color=#0000fe]6[/color]:
You summon a laser beam in the direction you are facing, dealing Physical damage.
 [color=#762ca7]7[/color]:
A meteor crashes down in front of your facing direction, dealing [color=#deb600]Earth[/color] damage.
 [color=#fe98bf]8[/color]:
All of your party member's health and mana is restored.
	"""
	player_perkskill_text.bbcode_text = createsugarroll_text.format({
		"cooldown": str(Global.player_perks["CreateSugarRoll"]["cooldown"]),
	}) + chaosmagic_text.format({
		"triggerchance": str(Global.player_perks["ChaosMagic"]["triggerchance"])
	})
	
	
	
func update_visbility():
	pass
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

#func _on_PlayerPerk_CreateSugarRoll_toggled(button_pressed):
#	update_perk_skill_selection_ui("Player", "CreateSugarRoll")
#
#func _on_PlayerPerk_ChaosMagic_toggled(button_pressed):
#	update_perk_skill_selection_ui("Player", "ChaosMagic")


func _on_CloseButtonMainUI_pressed():
	visible = false
	get_parent().get_node("CharactersUI").visible = true


func _on_Player_PerkSkillSelectionOption_item_selected(index):
	match index:
		0:
			update_perk_skill_selection_ui("Player", "CreateSugarRoll")
		1:
			update_perk_skill_selection_ui("Player", "ChaosMagic")
