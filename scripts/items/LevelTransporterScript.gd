extends StaticBody2D

onready var transition : CanvasLayer= get_parent().get_node("SceneTransition")
onready var colorrect : ColorRect = get_parent().get_node("SceneTransition/ColorRect")
onready var PLAYER : Area2D = get_parent().get_node("Player").get_node("Area2D")
export var Destination : PackedScene

func _ready():
	$Label.visible = false

func _process(delta):
	if $Area2D.overlaps_area(PLAYER):
		$Label.visible = true
		if Input.is_action_just_pressed("ui_use"):
			colorrect.visible = true
			transition.transition()
			yield(get_tree().create_timer(1), "timeout")
			get_parent().queue_free()
#			get_tree().change_scene("res://scenes/levels/Level" + str(int(get_tree().current_scene.name) + 1) + ".tscn")
			get_tree().change_scene(str(Destination))

func _on_Area2D_area_exited(area):
	$Label.visible = false
