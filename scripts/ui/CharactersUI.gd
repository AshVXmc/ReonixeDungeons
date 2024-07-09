class_name CharactersUI extends Control

onready var characterselection_ui = get_parent().get_parent().get_node("CharacterSelectionUI")
func _ready():
#	visible = true
	update_ui()
	

func update_ui():
	visible = false
	get_parent().get_node("CharacterSkillsControl").visible = false
	get_parent().get_node("CharacterTalentsControl").visible = false
	$NinePatchRect/PlayerStatsLabel.bbcode_text = "[center]Max HP: " + str(Global.player_skill_multipliers["BaseHearts"] * 10) + "\n" + "Attack: " + str(Global.attack_power)

func _process(delta):
	pass
#	if Input.is_action_just_pressed("open_loadout"):
#		toggle_ui()

func toggle_ui():
	visible = true if !visible else false
	get_parent().get_parent().get_node("CharacterSelectionUI/Control").visible = true
	if get_parent().layer == 1:
		get_parent().layer = 2
	elif get_parent().layer == 2:
		get_parent().layer = 1
#	get_tree().paused = true if !get_tree().paused else false
func handle_levelling_up():
	pass

func _on_PlayerOpenTalentButton_pressed():
	get_parent().get_node("CharacterTalentsControl").visible = true

func _on_PlayerOpenSkillsButton_pressed():
	get_parent().get_node("CharacterSkillsControl").visible = true

func _on_CloseButtonMainUI_pressed():
	characterselection_ui.layer = 2
	toggle_ui()
