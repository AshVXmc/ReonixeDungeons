extends KinematicBody2D

const TYPE : String = "Enemy"
const FLOOR = Vector2(0, -1)
const SPEED : int = 300
const GRAVITY : int = 95
const MAX : int = 3
const MIN : int = 1
const SHOCKWAVE : PackedScene = preload("res://scenes/enemies/bosses/Shockwave.tscn")

var velocity = Vector2()
var direction : int = -1
var is_dead : bool = false 
var player = null
var is_attacking : bool = false
export var HP : int = 12

# ATTACK PATTERNS
# Sends shockwaves on two directions while is on floor.
# Dash(?)
func _ready():
	$AttackTimer.start()

func _on_AttackTimer_timeout():
	downwards_slam()
func _physics_process(delta):
	if HP <= 0:
		queue_free()
	
	if velocity.x > 0 or velocity.x < 0 and !is_dead and !is_attacking:
		$AnimatedSprite.play("Default")
	if velocity.y > 0 and velocity.x == 0:
		$AnimatedSprite.play("Slam")
	if is_on_floor() and !is_attacking:
		velocity.x = SPEED * direction
	if direction == 1 and !is_dead:
		$AnimatedSprite.flip_h = false
	elif !is_dead:
		$AnimatedSprite.flip_h = true

	velocity.y += GRAVITY
	velocity = move_and_slide(velocity, FLOOR)
	
	if is_on_wall() or $RayCast2D.is_colliding():
		direction *= -1
		$RayCast2D.position.x *= -1

func random_jump():
	velocity.y += 100
	is_attacking = true
	
# Teleports upward and slams downwards (from one of the three pillar spots)
# Note: test this on the arena scene so it doesn't produce a null instance error
func downwards_slam():

	var rng : RandomNumberGenerator = RandomNumberGenerator.new()
	var pos1 : Position2D = get_parent().get_node("Position2D1")
	var pos2 : Position2D = get_parent().get_node("Position2D2")
	var pos3 : Position2D = get_parent().get_node("Position2D3")
	rng.randomize()
	var randomInteger : int = rng.randi_range(MIN, MAX)
	match randomInteger:
		1:
			position.x = pos1.position.x
			position.y = pos1.position.y
			on_slam()
		2:
			position.x = pos2.position.x
			position.y = pos2.position.y
			on_slam()
		3:
			position.x = pos3.position.x
			position.y = pos3.position.y
			on_slam()

func on_slam():
	$ShockTimer.start()
	is_attacking = true
	velocity.x = 0
	yield(get_tree().create_timer(1.25), "timeout")
	is_attacking = false

func _on_Area2D_area_entered(area):
	if area.is_in_group("Sword") or area.is_in_group("Fireball") and HP > 0:
		HP -= 1
		set_modulate(Color(2,0.5,0.3,1))
		$HurtTimer.start()
		
	if area.is_in_group("Player"):
		velocity.x = 0
		
func _on_HurtTimer_timeout():
	set_modulate(Color(1,1,1,1))


func _on_ShockTimer_timeout():
	var shockwaveright = SHOCKWAVE.instance()
	var shockwaveleft = SHOCKWAVE.instance()
	get_parent().add_child(shockwaveright)
	get_parent().add_child(shockwaveleft)
	shockwaveright.position = $Position2DRight.global_position
	shockwaveleft.flip_sw(-1)
	shockwaveleft.position = $Position2DLeft.global_position
	


func _on_JumpTimer_timeout():
	velocity.y += 500
