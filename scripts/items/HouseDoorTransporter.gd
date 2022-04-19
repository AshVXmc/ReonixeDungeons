class_name HouseDoor extends Node2D

#onready var transition : CanvasLayer= get_parent().get_node("SceneTransition")
## Dependency
#onready var colorrect : ColorRect = get_parent().get_node("SceneTransition/ColorRect")
onready var PLAYER : Area2D = get_parent().get_node("Player").get_node("Area2D")
export var Position_X : float
export var Position_Y : float

signal door_opened()

func _ready():
	$Label.visible = false
	connect("door_opened", get_parent().get_node("Player"), "door_opening")
func _process(delta):
	if $Area2D.overlaps_area(PLAYER):
		$Label.visible = true
		if Input.is_action_just_pressed("ui_use"):
#			colorrect.visible = true
#			transition.transition()
			get_parent().get_node("Player").position.x = Position_X
			get_parent().get_node("Player").position.y = Position_Y

func _on_Area2D_area_exited(area):
	$Label.visible = false
