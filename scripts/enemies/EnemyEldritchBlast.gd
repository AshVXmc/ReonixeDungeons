class_name EnemyEldritchBlast extends KinematicBody2D

const MAX_SPEED : int = 300
var speed : int = MAX_SPEED
export (int) var x_direction = -1
var elemental_type = "Physical"
var atk_value : int = 1 * Global.enemy_level_index 
onready var target = get_parent().get_node("Player")
export var steer_force = 150

var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO
func _ready():
	$Area2D.add_to_group(elemental_type)
	$Area2D.add_to_group(str(atk_value))
	
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
	acceleration += seek()
	velocity += acceleration * delta
	velocity = velocity.clamped(speed)
	rotation = velocity.angle()
	position += velocity * delta



func _on_Area2D_area_entered(area):
	if area.is_in_group("Player") or area.is_in_group("Tilemap"):
		call_deferred('free')
	if area.is_in_group("TempusTardus"):
		speed *= 0.2


func _on_Area2D_body_entered(body):
	if body.is_in_group("Tilemap"):
		call_deferred('free')


func _on_Area2D_area_exited(area):
	if area.is_in_group("TempusTardus"):
		speed = MAX_SPEED


func _on_Timer_timeout():
	pass
#	call_deferred('free')
