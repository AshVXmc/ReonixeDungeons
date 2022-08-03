class_name SwordSlashEffect extends Node2D

onready var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	var randint = rng.randi_range(1,3)
	match randint:
		1:
			$AnimationPlayer.play("SwordSlash1")
		2:
			$AnimationPlayer.play("SwordSlash2")
		3:
			$AnimationPlayer.play("SwordSlash3")
