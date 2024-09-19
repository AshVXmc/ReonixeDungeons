class_name SnowBoulder extends KinematicBody2D
 
var velocity = Vector2()
var direction : int = 1
var destroyed : bool = false
const SPEED : int = 360
const GRAVITY : int = 8
const decrement_constant : float = 0.3

func _ready():
	$Area2D.add_to_group(str(Global.glaciela_attack * Global.glaciela_skill_multipliers["SnowBoulder"] / 100))
	if direction == 1:
		$AnimationPlayer.play("rollright")
	elif direction == -1:
		$AnimationPlayer.play("rollleft")
	$SizeDecayTimer.start()
func _physics_process(delta):
	if !destroyed:
		velocity.x = SPEED * delta * direction
		velocity.y = GRAVITY
	else:
		velocity.x = 0
	velocity = move_and_slide(velocity,Vector2.UP)
	translate(velocity)
	if direction == 1:
		$Area2D/CollisionShape2D.position.x = 42
	elif direction == -1:
		$Area2D/CollisionShape2D.position.x = -42
	

func _on_Area2D_body_entered(body):
	if body.is_in_group("Tilemap") or body.is_in_group("PlayerEntity"):
		if direction == 1:
			direction = -1
			$AnimationPlayer.play("rollleft")
		elif direction == -1:
			direction = 1
			$AnimationPlayer.play("rollright")


func _on_Area2D_area_entered(area):
	if area.is_in_group("Sword") and $ManualKnockCooldown.is_stopped():
		if direction == 1:
			direction = -1
			$AnimationPlayer.play("rollleft")
		elif direction == -1:
			direction = 1
			$AnimationPlayer.play("rollright")
		$ManualKnockCooldown.start()


func _on_SizeDecayTimer_timeout():
	if $CollisionShape2D.shape.radius <= 10:
		call_deferred('free')
	else:
		$Sprite.scale.x -= decrement_constant
		$Sprite.scale.y -= decrement_constant
		$CollisionShape2D.shape.radius -= decrement_constant * 10
		$Area2D/CollisionShape2D.shape.extents.y -= 2
		$Particles2D.scale.x -= decrement_constant / 2
		$Particles2D.scale.y -= decrement_constant / 2
		$Particles2D.position.y -= decrement_constant * 16
