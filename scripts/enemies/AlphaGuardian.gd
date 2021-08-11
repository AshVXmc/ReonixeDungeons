extends KinematicBody2D

const TYPE : String = "Enemy"
const SPEED : int = 250
const GRAVITY : int = 95
const MAX : int = 3
const MIN : int = 1
const SHOCKWAVE : PackedScene = preload("res://scenes/enemies/bosses/Shockwave.tscn")
const GROUNDSHOCKWAVE : PackedScene = preload("res://scenes/enemies/bosses/GroundShock.tscn")
const JUMP : int = 1000
var velocity = Vector2(0,0)
var direction : int = -1
var is_dead : bool = false 
var player = null
var is_attacking : bool = false
export var HP : int = 20

# ATTACK PATTERNS
# Sends shockwaves on two directions while is on floor.
# Dash(?)
func _ready():

	$AttackTimer.start()
	$MeleeTimer.start()

func _on_AttackTimer_timeout():
	downwards_slam()

func _on_MeleeTimer_timeout():
	melee_attack()

# warning-ignore:unused_argument
func _physics_process(delta):
	if HP <= 0:
		queue_free()
	# attack collision flipping
	if !$AnimatedSprite.flip_h:
		get_node("AttackCollision").set_scale(Vector2(1,1))
	else:
		get_node("AttackCollision").set_scale(Vector2(-1,1))	
	if velocity.x > 0 or velocity.x < 0 and !is_dead and !is_attacking:
		$AnimatedSprite.play("Default")
	if is_on_floor() and !is_attacking:
		velocity.x = SPEED * direction
	if direction == 1 and !is_dead:
		$AnimatedSprite.flip_h = false
	elif !is_dead:
		$AnimatedSprite.flip_h = true

	velocity.y += GRAVITY
	velocity = move_and_slide(velocity , Vector2.UP)
	
	if is_on_wall() or $RayCast2D.is_colliding():
		direction *= -1
		$RayCast2D.position.x *= -1

func melee_attack():
	is_attacking = true
	velocity.x = 0
	yield(get_tree().create_timer(1.25), "timeout")
	$AttackCollision/CollisionPolygon2D.disabled = false
	velocity.x = 450 * direction
	velocity.y += -2200
	if !$AnimatedSprite.flip_h:
		$CollisionPolygon2D.position.x = -38.098
		$CollisionPolygon2D.position.y = -0.794
		$Area2D/CollisionPolygon2D.position.x = -38.098
		$Area2D/CollisionPolygon2D.position.y = -0.794
	else:
		$CollisionPolygon2D.position.x = 62.702
		$CollisionPolygon2D.position.y = -0.794
		$Area2D/CollisionPolygon2D.position.x = 62.702
		$Area2D/CollisionPolygon2D.position.y = -0.794
	yield(get_tree().create_timer(1), "timeout")
	velocity.x = SPEED * direction
	$AttackCollision/CollisionPolygon2D.disabled = true
	# default coordinates
	$CollisionPolygon2D.position.x = 7.937
	$CollisionPolygon2D.position.y = 0
	$Area2D/CollisionPolygon2D.position.x = 7.937
	$Area2D/CollisionPolygon2D.position.y = 0
	is_attacking = false	
		

	
	
	
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
	var rng : RandomNumberGenerator = RandomNumberGenerator.new()
	rng.randomize()
	var randint : int = rng.randi_range(0,1)
	match randint:
		0:
			double_wave_slam()
		1:
			smash()

# Smacks club to ground and four shockwaves come up from four spots
func smash():
	$MeleeTimer.stop()
	$GroundTimer.start()
	velocity.x = 0
	$AnimatedSprite.play("Slam")
	is_attacking = true
	yield(get_tree().create_timer(1), "timeout")
	is_attacking = false
	$MeleeTimer.start()
# Double shockwaves go brrrrr skiddy bip dop click dip bop
func double_wave_slam():
	$MeleeTimer.stop()
	$ShockTimer.start()
	$AnimatedSprite.play("Slam")
	is_attacking = true
	velocity.x = 0
	$Area2D.add_to_group("Enemy2")
	yield(get_tree().create_timer(1.25), "timeout")
	is_attacking = false
	$Area2D.remove_from_group("Enemy2")
	$MeleeTimer.start()

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
	

func _on_GroundTimer_timeout():
	var rng : RandomNumberGenerator = RandomNumberGenerator.new()
	rng.randomize()
	var randint : int = rng.randi_range(0,1)
	var gpos1 : Position2D = get_parent().get_node("GroundPos1")
	var gpos2 : Position2D = get_parent().get_node("GroundPos2")
	var gpos3 : Position2D = get_parent().get_node("GroundPos3")
	var gpos4 : Position2D = get_parent().get_node("GroundPos4")
	var groundwave1 : Node = GROUNDSHOCKWAVE.instance()
	var groundwave2 : Node = GROUNDSHOCKWAVE.instance()
	get_parent().add_child(groundwave1)
	get_parent().add_child(groundwave2)
	match randint:
		0:
			groundwave1.position.x = gpos1.position.x
			groundwave1.position.y = gpos1.position.y
			groundwave2.position.x = gpos3.position.x
			groundwave2.position.y = gpos3.position.y
		1:
			groundwave1.position.x = gpos2.position.x
			groundwave1.position.y = gpos2.position.y
			groundwave2.position.x = gpos4.position.x
			groundwave2.position.y = gpos4.position.y








