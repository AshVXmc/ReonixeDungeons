class_name BatProjectile extends Area2D

var velocity = Vector2()
const MAX_GRAVITY = 8
var GRAVITY = MAX_GRAVITY

onready var atk_value : float 
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
	$CollisionShape2D.disabled = true
	$HostileArea/CollisionShape2D.disabled = true
	$Area2D/CollisionPolygon2D.disabled = true
	$ExplosionParticles.emitting = true
	yield(get_tree().create_timer(0.25), "timeout")
	call_deferred('free')

func _on_BatProjectile_area_entered(area):
	if area.is_in_group("Player"):
		detonate()


func _on_BatProjectile_body_entered(body):
	if !body.is_in_group("Enemy"):
		detonate()


func _on_Area2D_area_entered(area):
	if area.is_in_group("TempusTardus"):
		GRAVITY *= 0.05


func _on_Area2D_area_exited(area):
	if area.is_in_group("TempusTardus"):
		GRAVITY = MAX_GRAVITY
