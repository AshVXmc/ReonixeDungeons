extends Control


#func start_challenge(stage : int):
#	get_parent().STAGE = stage
#	get_parent().initiate_enemy_wave(get_parent().STAGE, get_parent().WAVE)
#	call_deferred('free')
onready var transition : CanvasLayer = get_parent().get_parent().get_parent().get_node("SceneTransition")
# Dependency
onready var colorrect : ColorRect = get_parent().get_parent().get_parent().get_node("SceneTransition/ColorRect")
onready var character_selection_ui : CharacterSelectionUI = get_parent().get_parent().get_node("CharacterSelectionUI/Control")
# to access the dungeon entrance "load_scene

const GODDESS_TRIALS_LEVEL_PATH : String = "res://scenes/levels/GoddessTrialsLevel.tscn"

func _ready():
	close_ui()

func _on_EnterStageButton_pressed(extra_arg_0):
	# extra_arg_0 is a positive integer bigger than 0
	# represents the stage no/index (e.g: 1, 2, 3, etc)
	# IMPORTANT: click signals > pressed > right click, edit
	# bind the index of the stage to extra_arg_0
	Global.goddess_trials_stages["CurrentStage"] = extra_arg_0
	visible = false
	character_selection_ui.get_parent().layer = 3
	character_selection_ui.initialize_ui()
	character_selection_ui.connect("chosen_party_members", self, "load_next_scene")
#	get_tree().paused = false
#	$LevelSelectionUI.layer = 1
#	start_challenge(extra_arg_0)

func load_next_scene(slot_one : String, slot_two : String, slot_three : String):
	colorrect.visible = true
	Global.equipped_characters = [slot_one, slot_two, slot_three]

#	print(Global.equipped_characters)
#	print(Global.alive)
	Global.assign_health_points()
	Global.assign_mana_points()

	get_parent().get_parent().get_parent().get_node("Player").is_shopping = true
	transition.transition()
	yield(get_tree().create_timer(1), "timeout")
	get_parent().queue_free()
	get_tree().change_scene(GODDESS_TRIALS_LEVEL_PATH)
	
func enter_goddess_trial_stage_level(stage_index : int):
	pass
	
	
func initialize_ui():
	pass
	
func open_ui():
	get_parent().layer = 3
	visible = true
	get_tree().paused = true

func close_ui():
	get_parent().layer = 1
	visible = false
	get_tree().paused = false


func _on_CloseButtonMainUI_pressed():
	close_ui()
