class_name LevelTransporter extends Node2D

onready var transition : CanvasLayer= get_parent().get_node("SceneTransition")
# Dependency
onready var colorrect : ColorRect = get_parent().get_node("SceneTransition/ColorRect")
onready var PLAYER : Area2D = get_parent().get_node("Player").get_node("Area2D")
export var Destination : String
const closed : StreamTexture = preload("res://assets/terrain/door.png")
const opened : StreamTexture = preload("res://assets/terrain/door_opened.png")
var is_opened : bool = false
export var level_exit : bool = false
var level_completed_info : Dictionary 
signal door_opened()
signal relay_info_to_objective_list(enemy_count, opals_obtained, chests_opened)

func _ready():
	$LevelComplete/LevelCompleteControl.visible = false
	if level_exit:
		level_completed_info = {
			"EnemyCount": len(get_tree().get_nodes_in_group("EnemyEntity")),
			"OpalsObtained": 0,
			"ChestsOpened": 0
		}
	
	$Label.visible = false
	$Keybind.visible = false
	connect("door_opened", get_parent().get_node("Player"), "door_opening")
func _process(delta):
	if !is_opened:
		$Sprite.set_texture(closed)
	if $Area2D.overlaps_area(PLAYER):
		$Label.visible = true
		$Keybind.visible = true
		if Input.is_action_just_pressed("ui_use"):
			if !level_exit:
				emit_signal("door_opened")
				is_opened = true
				$Sprite.set_texture(opened)
				colorrect.visible = true
				transition.transition()
				yield(get_tree().create_timer(1), "timeout")
				get_parent().call_deferred('free')
				get_tree().change_scene(Destination)
			else:
				# to prevent pauseui being opened
				Global.is_opening_an_UI = true
				update_ui()
				get_tree().paused = true
				$LevelComplete.layer = 6
				$LevelComplete/LevelCompleteControl.visible = true
				

func update_ui():
	var current_enemies : int = len(get_tree().get_nodes_in_group("EnemyEntity"))
	$LevelComplete/LevelCompleteControl/EnemiesKilled.text = "Enemies killed: " + str(level_completed_info["EnemyCount"] - current_enemies) + "/" + str(level_completed_info["EnemyCount"])
#	calculate_xp(Global.equipped_characters)


func return_to_main_menu():
	pass
func record_opals_obtained(amount_added):
	level_completed_info["OpalsObtained"] += amount_added

func _on_Area2D_area_exited(area):
	$Label.visible = false
	$Keybind.visible = false


func _on_ReturnToMainMenu_pressed():
	$LevelComplete.layer = 1
#	get_parent().get_node("SceneTransition").layer = 10
#	get_parent().get_node("SceneTransition/ColorRect").visible = true
#	get_parent().get_node("SceneTransition").transition()
#	yield(get_tree().create_timer(1), "timeout")
	get_tree().change_scene("res://scenes/levels/hublevel/HubLevel.tscn")
	call_deferred('free')
