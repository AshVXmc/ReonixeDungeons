class_name BatProjectile extends Area2D

var velocity = Vector2()
const GRAVITY = 12
onready var atk_value : float = 0.1
var elemental_type = "Physical"
var is_detonating: bool = false
func _ready():
	$AnimatedSprite.play("default")

func _physics_process(delta):
	if !is_detonating:
		velocity.y = GRAVITY
		translate(velocity)

func detonate():
	is_detonating = true
#	$Area2D.add_to_group("Enemy")
#	$Area2D.add_to_group("Hostile")
#	$Area2D.add_to_group("Projectile")
#	$Area2D.add_to_group(str(atk_value))
	$AnimatedSprite.visible = false
	$TrailParticles.visible = false
	
	$Area2D/CollisionPolygon2D.disabled = false
	$ExplosionParticles.emitting = true
	yield(get_tree().create_timer(0.85), "timeout")
	call_deferred('free')

func _on_BatProjectile_area_entered(area):
	if area.is_in_group("Player"):
		detonate()


func _on_BatProjectile_body_entered(body):
	detonate()
