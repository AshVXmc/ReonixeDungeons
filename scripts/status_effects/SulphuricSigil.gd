class_name SulphuricSigil extends Node2D


onready var FIRE_DETIONATION_PARTICLE = preload("res://scenes/particles/FireDetonationParticle.tscn")
var stacks : int = 0
const MAX_STACKS : int = 3
# Perform two slashes in an X-shaped pattern like ayato's C6 effect. Has a small CD

func _ready():
	$DurationTimer.start()
	$SecondSlash.visible = false
	$FirstSlash.visible = false

func detonate():
	pass

func trigger_slash():
	$AnimationPlayer.play("SulphuricSigilSlash")
	


func _on_Area2D_body_entered(body):
	if body.is_in_group("EnemyEntity"):
		body.add_to_group("MarkedWithSulphuricSigil")
	
func _on_DurationTimer_timeout():
	get_parent().remove_from_group("MarkedWithSulphuricSigil")
	$AnimationPlayer.play("Destroy")


func _on_Area2D_area_entered(area):
	pass # Replace with function body.
