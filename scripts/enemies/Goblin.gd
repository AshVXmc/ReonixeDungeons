class_name Goblin extends KinematicBody2D

export var HP : int = 6
export var flipped : bool = false
var velocity = Vector2()
var direction : int = 1
var is_dead : bool = false 
const TYPE : String = "Enemy"
const FLOOR = Vector2(0, -1)
const SPEED : int = 315
const GRAVITY : int = 45
var is_staggered : bool = false
const FROZEN = preload("res://scenes/status_effects/FrozenStatus.tscn")
const LOOT = preload("res://scenes/items/LootBag.tscn")
onready var AREA_LEFT : Area2D = $Left
onready var AREA_RIGHT : Area2D = $Right
onready var PLAYER = get_parent().get_node("Player").get_node("Area2D")
var is_frozen : bool = false

func _physics_process(delta):
	
	if flipped:
		$Sprite.flip_h = true
	velocity.y += GRAVITY
	if !is_staggered and !is_frozen:
		velocity = move_and_slide(velocity, FLOOR)
	$Sprite.play("Idle") if velocity.x == 0 else $Sprite.play("Attacking")
	if !is_staggered and !is_frozen: 
		if AREA_LEFT.overlaps_area(PLAYER):
			$Sprite.flip_h = false
			if !$Sprite.flip_h:
				yield(get_tree().create_timer(0.4),"timeout")
				velocity.x = -SPEED
		if AREA_RIGHT.overlaps_area(PLAYER):
			$Sprite.flip_h = true
			if $Sprite.flip_h:
				yield(get_tree().create_timer(0.4),"timeout")
				velocity.x = SPEED

func _on_Area2D_area_entered(area):
	if area.is_in_group("Sword") or area.is_in_group("Fireball") and HP > 0:
		HP -= 1
		parse_damage()
	elif area.is_in_group("Sword2"):
		HP -= 3
		parse_damage()
	if area.is_in_group("Player"):
		is_staggered = true
		yield(get_tree().create_timer(1), "timeout")
		is_staggered = false
	if area.is_in_group("Frozen"):
		is_frozen = true

func parse_damage():
	is_staggered = true
	velocity.x = 0
	$Sprite.set_modulate(Color(2,0.5,0.3,1))
	if $HurtTimer.is_stopped():
		$HurtTimer.start()
#	if !$Sprite.flip_h:
#		velocity.x = 1000
#	else:
#		velocity.x = -1000
	if HP <= 0:
		var loot = LOOT.instance()
		var lootrng : RandomNumberGenerator = RandomNumberGenerator.new()
		lootrng.randomize()
		var randomint = lootrng.randi_range(1,3)
		if randomint == 1:
			get_parent().add_child(loot)
			loot.Tier = 2
			loot.position = $Position2D.global_position
		queue_free()
		Global.enemies_killed += 1
func _on_HurtTimer_timeout():
	is_staggered = false
	$Sprite.set_modulate(Color(1,1,1,1))

func _on_AttackingTimer_timeout():
	velocity.x = 0



func _on_Left_area_exited(area):
	yield(get_tree().create_timer(2), "timeout")
	velocity.x = 0


func _on_Right_area_exited(area):
	yield(get_tree().create_timer(2), "timeout")
	velocity.x = 0


func _on_Area2D_area_exited(area):
	if area.is_in_group("Frozen"):
		is_frozen = false
