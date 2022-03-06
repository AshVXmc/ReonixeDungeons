class_name Bat extends KinematicBody2D

const TYPE : String = "Enemy"
var SPEED : int = 180
var velocity: Vector2 = Vector2.ZERO
var is_dead : bool = false
var health : int = 1
var direction : int = 1
var player = null

func _physics_process(delta):
	if !is_dead:
		$AnimatedSprite.play("Idle")
		velocity = Vector2.ZERO
		if player:
			velocity = position.direction_to(player.position) * SPEED
			velocity = move_and_slide(velocity)


func _on_Area2D_area_entered(area):
	if area.is_in_group("Sword") or area.is_in_group("Fireball"):
		queue_free()

# Player detector
func _on_Detector_body_entered(body):
	if body.get("TYPE") == "Player":
		player = body 

func _on_Detector_body_exited(body):
	if body.get("TYPE") == "Player":
		player = null 

