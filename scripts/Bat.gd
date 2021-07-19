extends KinematicBody2D

const TYPE = "Enemy"
const SPEED = 100
var velocity = Vector2()
var is_dead : bool = false
var health : int = 1
var direction : int = 1



func _physics_process(delta):
	if !is_dead:
		$AnimatedSprite.play("Idle")
		

		


func _on_Area2D_area_entered(area):
	if area.is_in_group("Player"):
		queue_free()
