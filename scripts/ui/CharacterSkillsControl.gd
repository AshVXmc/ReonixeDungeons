class_name CharacterSkillsControl extends Control

onready var skill_type_option_button = $NinePatchRect/SkillsControl/PlayerControl/SkillTypeOptionButton
onready var player_pskill = $NinePatchRect/SkillsControl/PlayerControl/PrimarySkillScrollContainer
onready var player_pskill_text = $NinePatchRect/SkillsControl/PlayerControl/PrimarySkillScrollContainer/VBoxContainer/RichTextLabel
onready var player_sskill = $NinePatchRect/SkillsControl/PlayerControl/SecondarySkillScrollContainer
onready var player_sskill_text = $NinePatchRect/SkillsControl/PlayerControl/SecondarySkillScrollContainer/VBoxContainer/RichTextLabel
onready var player_tskill = $NinePatchRect/SkillsControl/PlayerControl/TertiarySkillScrollContainer
onready var player_tskill_text = $NinePatchRect/SkillsControl/PlayerControl/TertiarySkillScrollContainer/VBoxContainer/RichTextLabel
onready var player_perkskill = $NinePatchRect/SkillsControl/PlayerControl/PerkSkillScrollContainer
onready var player_perkskill_text = $NinePatchRect/SkillsControl/PlayerControl/PerkSkillScrollContainer/VBoxContainer/RichTextLabel
onready var player_node = get_parent().get_parent().get_node("Player")
onready var skills_ui_node = get_parent().get_parent().get_node("SkillsUI/Control")
onready var glaciela_pskill
onready var glaciela_sskill
onready var glaciela_tskill


func _ready():
	skill_type_option_button.add_item("Primary", 0)
	skill_type_option_button.add_item("Secondary", 1)
	skill_type_option_button.add_item("Tertiary", 2)
	skill_type_option_button.add_item("Perk", 3)
	_on_Player_SkillTypeOptionButton_item_selected(0)
	update_description_text()

# to update perk skill: access two functions
# first is update_perk_skill in player.tscn 
# second is update_perk_skill_ui in skillsui
func update_description_text():
	var firesaw_text = """[color=#ffd703]Flaming Firesaw[/color]
Twin flame blades spin around you for {duration} seconds, dealing [u]{firesawatk}% ATK[/u] as [color=#fd9628]Fire damage[/color] and instantly [color=#fd9628]Burning[/color] all nearby enemies.
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
		"cooldown": str(Global.player_skill_multipliers["FireballCD"])
	})
	
	var create_sugar_roll_text = """[color=#ffd703]Create Sugar Roll[/color]
Conjure a [color=#bda662]Sugar Roll[/color] at your location. A character can eat the roll, restoring health over time. The roll cannot be eaten if there are enemies nearby, and only one roll may exist in a level. 
Cooldown: {cooldown} seconds 
	"""
	player_perkskill_text.bbcode_text = create_sugar_roll_text.format({
		"cooldown": str(Global.player_perks["CreateSugarRoll"]["cooldown"])
	})
	
	
	
	
func _on_CloseButtonMainUI_pressed():
	visible = false
	get_parent().get_node("CharactersUI").visible = true


func _on_Player_SkillTypeOptionButton_item_selected(index):
	match index:
		0:
			player_pskill.visible = true
			player_sskill.visible = false
			player_tskill.visible = false
			player_perkskill_text.visible = false
		1:
			player_pskill.visible = false
			player_sskill.visible = true
			player_tskill.visible = false
			player_perkskill_text.visible = false
		2:
			player_pskill.visible = false
			player_sskill.visible = false
			player_tskill.visible = true
			player_perkskill_text.visible = false
		3:
			player_pskill.visible = false
			player_sskill.visible = false
			player_tskill.visible = false
			player_perkskill_text.visible = true

