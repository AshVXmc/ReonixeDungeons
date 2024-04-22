class_name DungeonEntrance extends Node2D

onready var transition : CanvasLayer= get_parent().get_node("SceneTransition")
# Dependency
onready var colorrect : ColorRect = get_parent().get_node("SceneTransition/ColorRect")
onready var PLAYER : Area2D = get_parent().get_node("Player").get_node("Area2D")

const closed : StreamTexture = preload("res://assets/terrain/hub_level/dungeon_entrance.png")
const opened : StreamTexture = preload("res://assets/terrain/hub_level/dungeon_entrance_opened.png")
var is_opened : bool = false
var destination : String 

func _ready():
	$Label.visible = false
	$Keybind.visible = false
func _process(delta):
	if !is_opened:
		$Sprite.set_texture(closed)
	if $Area2D.overlaps_area(PLAYER):
		$Label.visible = true
		$Keybind.visible = true
		if Input.is_action_just_pressed("ui_use") and $ButtonPressCD.is_stopped():
			$ButtonPressCD.start()
#			$CharacterSelectionUI/Control.initialize_ui()
			initialize_level_selection()
			is_opened = true
			$Sprite.set_texture(opened)
			colorrect.visible = true

func initialize_level_selection():
	$LevelSelectionUI/Control.visible = false
	Global.is_opening_an_UI = true
	update_level_list()
	$LevelSelectionUI/Control.visible = true
	get_tree().paused = true

func update_level_list():
	pass

func load_next_scene(slot_one : String, slot_two : String, slot_three : String):
	Global.equipped_characters = [slot_one, slot_two, slot_three]
#	Global.save_player_data()
	get_parent().get_node("Player").is_shopping = true
	transition.transition()
	yield(get_tree().create_timer(1), "timeout")
	get_parent().queue_free()
	get_tree().change_scene(destination)

func _on_Area2D_area_exited(area):
	$Label.visible = false
	$Keybind.visible = false


func _on_CloseButtonMainUI_pressed():
	Global.is_opening_an_UI = false
	$Sprite.set_texture(closed)
	$LevelSelectionUI/Control.visible = false
	get_tree().paused = false

func _on_1_pressed():
	
	destination = "res://scenes/levels/Level1.tscn"
	$CharacterSelectionUI/Control.initialize_ui()

func _on_2_pressed():
	destination = "res://scenes/levels/Level2.tscn"
	$CharacterSelectionUI/Control.initialize_ui()
func _on_3_pressed():
	destination = "res://scenes/levels/Level3.tscn"
	$CharacterSelectionUI/Control.initialize_ui()
