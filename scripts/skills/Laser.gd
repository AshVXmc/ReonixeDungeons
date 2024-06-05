class_name LaserBeam extends Node2D

# 1 = right facing, -1 = left facing
var direction : int = 1

#func _ready():
#	pass

func trigger_animation():
	if direction == 1:
		$AnimationPlayer.play("RightShoot")
	elif direction == -1:
		$AnimationPlayer.play("LeftShoot")

func start_damage_over_time():
	$Timer.start()

func stop_damage_over_time():
	$Timer.stop()

func _on_Timer_timeout():
	$Sprite/Area2D/CollisionShape2D.disabled = false if $Sprite/Area2D/CollisionShape2D.disabled == true else true
