extends Node2D

onready var transition : CanvasLayer= get_parent().get_node("SceneTransition")
onready var colorrect : ColorRect = get_parent().get_node("SceneTransition/ColorRect")
onready var PLAYER : Area2D = get_parent().get_node("Player").get_node("Area2D")
export var Destination : String
const closed : StreamTexture = preload("res://assets/terrain/door.png")
const opened : StreamTexture = preload("res://assets/terrain/door_opened.png")
var is_opened : bool = false

func _ready():
	$Label.visible = false

func _process(delta):
	if !is_opened:
		$Sprite.set_texture(closed)
	if $Area2D.overlaps_area(PLAYER):
		$Label.visible = true
		if Input.is_action_just_pressed("ui_use"):
			is_opened = true
			$Sprite.set_texture(opened)
			colorrect.visible = true
			transition.transition()
			yield(get_tree().create_timer(1), "timeout")
			get_parent().queue_free()
			get_tree().change_scene(Destination)

func _on_Area2D_area_exited(area):
	$Label.visible = false
