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

func _on_PlayerOpenSkillsButton_pressed():
	get_parent().get_node("CharacterSkillsControl").visible = true

func _on_CloseButtonMainUI_pressed():
	characterselection_ui.layer = 2
	toggle_ui()
	get_parent().get_parent().get_node("CharacterSelectionUI/Control").visible = true


# debug
#func _on_PlayerOpenSkillsButton_mouse_entered():
#	print("HOVERED OVER")
