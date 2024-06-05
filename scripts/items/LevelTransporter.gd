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
				$LevelComplete/LevelCompleteControl.visible = true
				

func update_ui():
	var current_enemies : int = len(get_tree().get_nodes_in_group("EnemyEntity"))
	$LevelComplete/LevelCompleteControl/EnemiesKilled.text = "Enemies killed: " + str(level_completed_info["EnemyCount"] - current_enemies) + "/" + str(level_completed_info["EnemyCount"])
	calculate_xp(Global.equipped_characters)


func calculate_xp(characters : Array):
	var xp_per_enemy : int = 3
	# character count is also the constant that will be used to 
	var character_count : int = 0
	for i in characters:
		if i != "":
			character_count += 1
	var total_xp_obtained = (level_completed_info["EnemyCount"] - len(get_tree().get_nodes_in_group("EnemyEntity"))) * xp_per_enemy * character_count
	var character_position_in_array : int = 0
	var leftover_xp : int = 0
	for c in characters:
		if c != "":
			var XP = total_xp_obtained / character_count
			Global.character_level_data[c][1] += XP
			while Global.character_level_data[c][1] >= Global.character_level_data[c][2]:
				leftover_xp  = Global.character_level_data[c][1] - Global.character_level_data[c][2]
				Global.character_level_data[c][1] = leftover_xp
				Global.character_level_data[c][2] += 10
				Global.character_level_data[c][0] += 1
			
			match character_position_in_array:
				0:
					$LevelComplete/LevelCompleteControl/Character1XPIncrease.text = "+" + str(XP) + "XP"
					$LevelComplete/LevelCompleteControl/Character1Level.text = "LV. " + str(Global.character_level_data[c][0])
					if leftover_xp > 0:
						# XP overflows, levels up once or multiple times
						$LevelComplete/LevelCompleteControl/Character1LevelUp.visible = true
						$LevelComplete/LevelCompleteControl/Character1XPProgress.text = str(leftover_xp) + "/" + str(Global.character_level_data[c][2])
					else:
						# XP doesn't overflow, doesn't level up
						$LevelComplete/LevelCompleteControl/Character1LevelUp.visible = false
						$LevelComplete/LevelCompleteControl/Character1XPProgress.text = str(Global.character_level_data[c][1]) + "/" + str(Global.character_level_data[c][2])
				1:
					$LevelComplete/LevelCompleteControl/Character2XPIncrease.text = "+" + str(XP) + "XP"
					$LevelComplete/LevelCompleteControl/Character2Level.text = "LV. " + str(Global.character_level_data[c][0])
					if leftover_xp > 0:
						# XP overflows, levels up once or multiple times
						$LevelComplete/LevelCompleteControl/Character2LevelUp.visible = true
						$LevelComplete/LevelCompleteControl/Character2XPProgress.text = str(leftover_xp) + "/" + str(Global.character_level_data[c][2])
					else:
						# XP doesn't overflow, doesn't level up
						$LevelComplete/LevelCompleteControl/Character2LevelUp.visible = false
						$LevelComplete/LevelCompleteControl/Character2XPProgress.text = str(Global.character_level_data[c][1]) + "/" + str(Global.character_level_data[c][2])
		character_position_in_array += 1


func return_to_main_menu():
	pass
func record_opals_obtained(amount_added):
	level_completed_info["OpalsObtained"] += amount_added

func _on_Area2D_area_exited(area):
	$Label.visible = false
	$Keybind.visible = false



