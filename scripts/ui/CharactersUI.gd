class_name CharactersUI extends Control

onready var characterselection_ui = get_parent().get_parent().get_node("CharacterSelectionUI")

func _ready():
#	visible = true
	update_ui()
	

func update_ui():
	visible = false
#	get_parent().get_node("PerfectDash").visible = false
	get_parent().get_node("CharacterSkillsControl").visible = false
	get_parent().get_node("CharacterTalentsControl").visible = false
	$NinePatchRect/PlayerStatsLabel.bbcode_text = "[center]Max HP: " + str(Global.player_skill_multipliers["BaseHearts"] * 10) + "\n" + "Attack: " + str(Global.attack_power)

func _process(delta):
	pass
#	if Input.is_action_just_pressed("open_loadout"):
#		toggle_ui()

func toggle_ui():
	print("LOADOUT SCREEN TOGGLED")
	visible = true if !visible else false
	grab_focus()
	if get_parent().layer == 1:
		get_parent().layer = 3
	elif get_parent().layer == 3:
		get_parent().layer = 1
	
	
	# for debug purposes only
#	get_parent().get_node("CharacterSkillsControl").print_out_layer()
	#####
	
#	get_parent().get_parent().get_node("CharacterSelectionUI/Control").visible = true	
#	get_tree().paused = true if !get_tree().paused else false
func handle_levelling_up():
	pass

func _on_PlayerOpenTalentButton_pressed():
	get_parent().get_node("CharacterTalentsControl").visible = true
	get_parent().get_node("CharacterTalentsControl/NinePatchRect/TalentTreeControl/GlacielaControl").visible = false
	get_parent().get_node("CharacterTalentsControl/NinePatchRect/TalentTreeControl/PlayerControl").visible = true
	get_parent().get_node("CharacterTalentsControl/NinePatchRect/TalentTreeControl/AgnetteControl").visible = false
func _on_GlacielaOpenTalentButton_pressed():
	get_parent().get_node("CharacterTalentsControl").visible = true
	get_parent().get_node("CharacterTalentsControl/NinePatchRect/TalentTreeControl/GlacielaControl").visible = true
	get_parent().get_node("CharacterTalentsControl/NinePatchRect/TalentTreeControl/PlayerControl").visible = false
	get_parent().get_node("CharacterTalentsControl/NinePatchRect/TalentTreeControl/AgnetteControl").visible = false
func _on_AgnetteOpenTalentButton_pressed():
	get_parent().get_node("CharacterTalentsControl").visible = true
	get_parent().get_node("CharacterTalentsControl/NinePatchRect/TalentTreeControl/GlacielaControl").visible = false
	get_parent().get_node("CharacterTalentsControl/NinePatchRect/TalentTreeControl/PlayerControl").visible = false
	get_parent().get_node("CharacterTalentsControl/NinePatchRect/TalentTreeControl/AgnetteControl").visible = true

func _on_PlayerOpenSkillsButton_pressed():
	get_parent().get_node("CharacterSkillsControl").visible = true
	get_parent().get_node("CharacterSkillsControl/NinePatchRect/SkillsControl/PlayerControl").visible = true
	get_parent().get_node("CharacterSkillsControl/NinePatchRect/SkillsControl/GlacielaControl").visible = false
	get_parent().get_node("CharacterSkillsControl/NinePatchRect/SkillsControl/AgnetteControl").visible = false
func _on_GlacielaOpenSkillsButton_pressed():
	get_parent().get_node("CharacterSkillsControl").visible = true
	get_parent().get_node("CharacterSkillsControl/NinePatchRect/SkillsControl/PlayerControl").visible = false
	get_parent().get_node("CharacterSkillsControl/NinePatchRect/SkillsControl/GlacielaControl").visible = true
	get_parent().get_node("CharacterSkillsControl/NinePatchRect/SkillsControl/AgnetteControl").visible = false
func _on_AgnetteOpenSkillsButton_pressed():
	get_parent().get_node("CharacterSkillsControl").visible = true
	get_parent().get_node("CharacterSkillsControl/NinePatchRect/SkillsControl/PlayerControl").visible = false
	get_parent().get_node("CharacterSkillsControl/NinePatchRect/SkillsControl/GlacielaControl").visible = false
	get_parent().get_node("CharacterSkillsControl/NinePatchRect/SkillsControl/AgnetteControl").visible = true


func _on_PlayerOpenSkinsButton_pressed():
	get_parent().get_node("CharacterSkinSelection").visible = true
	
func _on_GlacielaOpenSkinsButton_pressed():
	pass # Replace with function body.

func _on_AgnetteOpenSkinsButton_pressed():
	pass # Replace with function body.

func _on_CloseButtonMainUI_pressed():
	characterselection_ui.layer = 2
	toggle_ui()
	get_parent().get_parent().get_node("CharacterSelectionUI/Control").visible = true




