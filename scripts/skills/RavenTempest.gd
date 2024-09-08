class_name RavenTempest extends Node2D

var direction : int = 1

func _ready():
	global_position = get_parent().get_node("Player").global_position
	if direction == 1:
		$AnimationPlayer.play("strikeright")
	elif direction == -1:
		$AnimationPlayer.play("strikeleft")
