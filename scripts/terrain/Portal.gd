class_name DungeonPortal extends Node2D

# Input text
onready var PLAYER = get_parent().get_node("Player").get_node("Area2D")
export var Portal_ID : int 
var destination : String
onready var transition : CanvasLayer= get_parent().get_node("SceneTransition")
# Dependency
onready var colorrect : ColorRect = get_parent().get_node("SceneTransition/ColorRect") 
# 0 = Hub portal
# 1 = Level 5
var is_opened : bool = false
func _ready():
	$AnimatedSprite.play("default")
	$Label.visible = false
	$Keybind.visible = false
	$Particles2D.visible = false


func _process(delta):

	if $Area2D.overlaps_area(PLAYER):
		$Label.visible = true
#		$Keybind.visible = true
		if Input.is_action_just_pressed("ui_use") and $ButtonPressCD.is_stopped():
			pass
			$ButtonPressCD.start()
##			$CharacterSelectionUI/Control.initialize_ui()
			initialize_level_selection()
			is_opened = true
#			$Sprite.set_texture(opened)

func load_next_scene(slot_one : String, slot_two : String, slot_three : String):
	colorrect.visible = true
	Global.equipped_characters = [slot_one, slot_two, slot_three]
	Global.assign_health_points()
	get_parent().get_node("Player").is_shopping = true
	transition.transition()
	yield(get_tree().create_timer(1), "timeout")
	get_parent().queue_free()
	get_tree().change_scene(destination)

func initialize_level_selection():
	$LevelSelectionUI/Control.visible = false
#	Global.is_opening_an_UI = true
#	update_level_list()
	$LevelSelectionUI/Control.visible = true
	$LevelSelectionUI.layer = 3
	$CharacterSelectionUI.layer = 3
	get_tree().paused = true
	


func teleport_to_level(level_path : String):
	$Plaque/Control.visible = false
	$Particles2D.visible = true
	$Particles2D.emitting = true
	$Particles2D.one_shot = false
	get_parent().get_node("SceneTransition/ColorRect").visible = true
	get_parent().get_node("SceneTransition").transition()
	yield(get_tree().create_timer(1), "timeout")
	get_tree().change_scene(level_path)


func _on_Area2D_area_entered(area):
	if area.is_in_group("Player") and !$Label.visible:
		emit_signal("shopping")
		$Label.visible = true
		$Keybind.visible = true

func _on_Area2D_area_exited(area):
	if area.is_in_group("Player"):
		$Label.visible = false
		$Keybind.visible = false

func _on_yes_pressed():
	destination = "res://scenes/levels/EndlessLevel.tscn"
	$CharacterSelectionUI/Control.initialize_ui()
	$LevelSelectionUI/Control.visible = false

func _on_No_pressed():
	$LevelSelectionUI/Control.visible = false
	get_tree().paused = false
	$LevelSelectionUI.layer = 1
	$CharacterSelectionUI.layer = 1

