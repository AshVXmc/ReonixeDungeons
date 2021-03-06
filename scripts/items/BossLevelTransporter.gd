class_name BossLevelTransporter extends Node2D

onready var transition : CanvasLayer= get_parent().get_node("SceneTransition")
# Dependency
onready var colorrect : ColorRect = get_parent().get_node("SceneTransition/ColorRect")
onready var PLAYER : Area2D = get_parent().get_node("Player").get_node("Area2D")
export var Destination : String
const closed : StreamTexture = preload("res://assets/terrain/boss_door.png")
const opened : StreamTexture = preload("res://assets/terrain/boss_door_opened.png")
var is_opened : bool = false

# Select screen export variables
export var Boss_Name : String
export var Boss_Subname : String 
export var Description : String

signal door_opened()

func _ready():
	$Label.visible = false
	connect("door_opened", get_parent().get_node("Player"), "door_opening")
	$Plaque/Control/NinePatchRect/BossName.text = Boss_Name
	$Plaque/Control/NinePatchRect/BossSubname.text = Boss_Subname
	$Plaque/Control/NinePatchRect/Description.text = Description
func _process(delta):
	if !is_opened:
		$Sprite.set_texture(closed)
	if $Area2D.overlaps_area(PLAYER):
		$Label.visible = true
		if Input.is_action_just_pressed("ui_use"):
			emit_signal("door_opened")
			is_opened = true
			$Sprite.set_texture(opened)
			colorrect.visible = true
			transition.transition()
			yield(get_tree().create_timer(1), "timeout")
			get_parent().queue_free()
			get_tree().change_scene(Destination)

func _on_Area2D_area_exited(area):
	$Label.visible = false


func _on_EnterButton_pressed():
	pass # Replace with function body.
