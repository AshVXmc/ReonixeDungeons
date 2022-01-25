class_name JesterGoblin extends KinematicBody2D

export var HP : int = 5
export var flipped : bool = false
var velocity = Vector2()
var is_dead : bool = false 
const TYPE : String = "Enemy"
const FLOOR = Vector2(0, -1)
const SPEED : int = 275
const GRAVITY : int = 45
var is_staggered : bool = false
var spinning : bool = false

const LOOT : PackedScene = preload("res://scenes/items/LootBag.tscn")
const FIREBALL : PackedScene = preload("res://scenes/Fireball.tscn")
onready var PLAYER = get_parent().get_node("Player").get_node("Area2D")

func _ready():
	$StateTimer.start()

func _physics_process(delta):
	if flipped:
		$Sprite.flip_h = true
	if !is_staggered:
		velocity = move_and_slide(velocity, FLOOR)
	# Animation
	if !spinning:
		$Sprite.play("Idle") if velocity.x == 0 else $Sprite.play("Attacking")
	else:
		$Sprite.play("Spin")
	velocity.y += GRAVITY
	
	 
	if !is_staggered:
		if $Left.overlaps_area(PLAYER):
			$Sprite.flip_h = false
			if !$Sprite.flip_h:
				yield(get_tree().create_timer(0.4),"timeout")
				if !spinning:
					velocity.x = -SPEED
				else:
					velocity.x = -SPEED - 75
		if $Right.overlaps_area(PLAYER):
			$Sprite.flip_h = true
			if $Sprite.flip_h:
				yield(get_tree().create_timer(0.4),"timeout")
				if !spinning:
					velocity.x = SPEED
				else:
					velocity.x = SPEED + 75

func return_to_sender():
	var fireball : Fireball = FIREBALL.instance()
	if velocity.x > 0:
		get_parent().add_child(fireball)
		fireball.flip_fireball(1)
		fireball.position = $RightPos.global_position
	else:
		get_parent().add_child(fireball)
		fireball.flip_fireball(-1)
		fireball.position = $LeftPos.global_position

func _on_Area2D_area_entered(area):
	if spinning and area.is_in_group("Fireball"):
		return_to_sender()
	if area.is_in_group("Sword") or area.is_in_group("Fireball") and HP > 0 and !spinning:
		HP -= 1
		velocity.x = 0
		set_modulate(Color(2,0.5,0.3,1))
#		is_staggered = true
		$HurtTimer.start()
		if HP <= 0:
			var loot = LOOT.instance()
			var lootrng : RandomNumberGenerator = RandomNumberGenerator.new()
			lootrng.randomize()
			var randomint = lootrng.randi_range(1,3)
			if randomint == 1:
				get_parent().add_child(loot)
				loot.position = $Position2D.global_position
			queue_free()
	if area.is_in_group("Player"):
		is_staggered = true
		yield(get_tree().create_timer(1), "timeout")
		is_staggered = false

func _on_HurtTimer_timeout():
	set_modulate(Color(1,1,1,1))
	is_staggered = false

func _on_AttackingTimer_timeout():
	velocity.x = 0

func _on_SpinTimer_timeout():
	spinning = false

func _on_StateTimer_timeout():
	if !spinning:
		spinning = true
		$Area2D.add_to_group("Spinning")
	else:
		spinning = false
		$Area2D.remove_from_group("Spinning")
	$StateTimer.start()
