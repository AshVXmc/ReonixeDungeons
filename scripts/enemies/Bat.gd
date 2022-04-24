class_name Bat extends KinematicBody2D

const TYPE : String = "Enemy"
var SPEED : int = 180
var velocity: Vector2 = Vector2.ZERO
var is_dead : bool = false
var HP : int = 2
var direction : int = 1
var player = null
const LOOT : PackedScene = preload("res://scenes/items/LootBag.tscn")
var rng : RandomNumberGenerator = RandomNumberGenerator.new()

func _physics_process(delta):
	if !is_dead:
		$AnimatedSprite.play("Idle")
		velocity = Vector2.ZERO
		if player:
			velocity = position.direction_to(player.position) * SPEED
			velocity = move_and_slide(velocity)


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

