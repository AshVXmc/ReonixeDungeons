class_name EnemyEldritchBlast extends KinematicBody2D

const MAX_SPEED : int = 335
var speed : int = MAX_SPEED
export (int) var x_direction = -1

onready var target = get_parent().get_node("Player")
export (int) var steer_force = 300

var elemental_type : String = "Physical"
var atk_value : float = 0.75 *  Global.enemy_level_index + 1
var slowdown_coefficient : float = 0.65 
var slowdown_duration : float = 2.5

var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO
var is_priming_for_explosion : bool = false

func _ready():
	$ExplosionArea2D/CollisionShape2D.disabled = true

func start(_transform, _target):
	global_transform = _transform
	rotation += rand_range(-0.09, 0.09)
	velocity = transform.x * speed
	target = _target

func seek():
	var steer = Vector2.ZERO
	if target:
		var desired = (target.position - position).normalized() * speed
		steer = (desired - velocity).normalized() * steer_force
	return steer
	
func _physics_process(delta):
	if !is_priming_for_explosion:
		acceleration += seek()
		velocity += acceleration * delta
		velocity = velocity.clamped(speed)
		rotation = velocity.angle()
		position += velocity * delta

func explode():
	is_priming_for_explosion = true
	$AnimationPlayer.play("Explode")
	$Particles2D.emitting = false
	$Particles2D.visible = false
	$PlayerDetectorArea2D/CollisionShape2D.disabled = true
	yield(get_tree().create_timer(0.4), "timeout")
	$PurpleSmokeParticle.emitting = true
	$ExplosionArea2D/CollisionShape2D.disabled = false
	$Sprite.visible = false
	yield(get_tree().create_timer(0.3), "timeout")
	call_deferred('free')
	
func _on_Area2D_area_entered(area):
	if area.is_in_group("Player") or area.is_in_group("Tilemap"):
		explode()
	if area.is_in_group("Sword"):
		explode()
	if area.is_in_group("TempusTardus"):
		speed *= 0.2


func _on_Area2D_body_entered(body):
	pass
#	if body.is_in_group("Tilemap"):
#		call_deferred('free')


func _on_Area2D_area_exited(area):
	if area.is_in_group("TempusTardus"):
		speed = MAX_SPEED


func _on_Timer_timeout():
	explode()



func _on_PlayerDetectorArea2D_area_entered(area):
	if area.is_in_group("Player"):
		explode()
