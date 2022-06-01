class_name TargetingMissile extends Node2D

func _ready():
	yield(get_tree().create_timer(0.25),"timeout")
	$AnimationPlayer.play("Pulse")
	yield(get_tree().create_timer(1),"timeout")
	pass


func _on_Area2D_area_entered(area):
	pass # Replace with function body.
