class_name Bat extends KinematicBody2D

const TYPE : String = "Enemy"
var SPEED : int = 180
var steer_force = 100
var velocity: Vector2 = Vector2.ZERO
var is_dead : bool = false
export var HP : int = 3
var direction : int = 1
var player = null
const LOOT : PackedScene = preload("res://scenes/items/LootBag.tscn")
var rng : RandomNumberGenerator = RandomNumberGenerator.new()
var target = null
var acceleration = Vector2.ZERO

func _ready():
	$AnimatedSprite.play("Idle")
func start(_transform, _target):
	
	global_transform = _transform
#	rotation += rand_range(-0.09, 0.09)
	velocity = transform.x * SPEED
	target = _target
	
func seek():
	var steer = Vector2.ZERO
	if target:
		var desired = (target.position - position).normalized() * SPEED
		steer = (desired - velocity).normalized() * steer_force
		return steer
	
func _physics_process(delta):
	target = get_player()
	if target and get_parent().get_node("Player/Area2D").overlaps_area($Detector):
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

func _on_Area2D_area_entered(area):
	if area.is_in_group("Sword") or area.is_in_group("Fireball"):
		drop_loot()
		queue_free()
		Global.enemies_killed += 1

func drop_loot():
	var loot = LOOT.instance()
	var lootrng : RandomNumberGenerator = RandomNumberGenerator.new()
	lootrng.randomize()
	var randomint = lootrng.randi_range(1,6)
	if randomint == 1:
		get_parent().add_child(loot)
		loot.position = $Position2D.global_position


# Player detector
func _on_Detector_body_entered(body):
	if body.get("TYPE") == "Player":
		player = body 

func _on_Detector_body_exited(body):
	if body.get("TYPE") == "Player":
		player = null 

