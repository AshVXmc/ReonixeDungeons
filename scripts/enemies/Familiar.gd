class_name Familiar extends KinematicBody2D

const TYPE : String = "Enemy"
var SPEED : int = 250
var steer_force = 100
var velocity: Vector2 = Vector2.ZERO
var is_dead : bool = false
var HP : int = 2
var direction : int = 1
var player = null
var target = null
const LOOT : PackedScene = preload("res://scenes/items/LootBag.tscn")
var rng : RandomNumberGenerator = RandomNumberGenerator.new()
var acceleration = Vector2.ZERO
var staggered : bool = false

func _ready():
	$AnimatedSprite.play("Idle")
func start(_transform, _target):
	global_transform = _transform
	velocity = transform.x * SPEED
	target = _target
	
func seek():
	var steer = Vector2.ZERO
	if target and !staggered:
		var desired = (target.position - position).normalized() * SPEED
		steer = (desired - velocity).normalized() * steer_force
		return steer
	
func _physics_process(delta):
	target = get_player()
	if target and get_parent().get_node("Player/Area2D").overlaps_area($Detector) and !staggered:
		acceleration += seek()
		velocity += acceleration * delta
		velocity = velocity.clamped(SPEED)
		position += velocity * delta
	elif !get_parent().get_node("Player/Area2D").overlaps_area($Detector):
		velocity.x = 0
		velocity.y = 0


func get_player():
	var player = get_parent().get_node("Player")
	return player

# Player detector
func _on_Detector_body_entered(body):
	if body.get("TYPE") == "Player":
		player = body 

func _on_Detector_body_exited(body):
	if body.get("TYPE") == "Player":
		player = null 


func _on_DeathTimer_timeout():
	queue_free()


func _on_Area2D_area_entered(area):
	if area.is_in_group("Sword") or area.is_in_group("Fireball"):
		queue_free()
		Global.enemies_killed += 1
	if area.is_in_group("Player"):
		staggered = true
		$StaggerTimer.start()


func _on_StaggerTimer_timeout():
	staggered = false
