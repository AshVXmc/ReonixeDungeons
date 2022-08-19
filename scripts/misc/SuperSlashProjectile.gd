class_name SuperSlashProjectile extends Area2D

const TYPE : String = "SuperSlashProjectile"
var SPEED : int = 600
var velocity = Vector2()
var direction : int = 1
var destroyed : bool = false

func _ready():
	add_to_group(str(Global.attack_power * 1.75))
func _physics_process(delta):
	if !destroyed:
		velocity.x = SPEED * delta * direction
	translate(velocity)

func flip_projectile(p_direction : int):
	direction = p_direction
	$Sprite.flip_h = true


func _on_DestroyedTimer_timeout():
	queue_free()
