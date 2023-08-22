class_name AlphaGuardian extends KinematicBody2D

const TYPE : String = "Enemy"
const SPEED : int = 300
const GRAVITY : int = 95
const MAX : int = 3
const MIN : int = 1
const SHOCKWAVE : PackedScene = preload("res://scenes/enemies/bosses/Shockwave.tscn")
const GROUNDSHOCKWAVE : PackedScene = preload("res://scenes/enemies/bosses/GroundShock.tscn")
const JUMP : int = 1000
var velocity = Vector2(0,0)
var direction : int = -1
var is_dead : bool = false 
onready var player = get_parent().get_node("Player/Area2D")
onready var camera = get_parent().get_node("Player/Camera2D")
var is_attacking : bool = false
var is_taking_damage : bool = false
export var maxHP : float = 35
export var HP : float = 35
var shake : float = 5
var is_shaking : bool = false
var jumping : bool = false

func _ready():
	$AttackTimer.start()
	$JumpTimer.start()

func _on_AttackTimer_timeout():
	on_slam()

func _physics_process(_delta):
	if !is_dead:
		# Health counter
		var currentHealthdisplay : int = int(ceil((HP / maxHP) * 100))
		$Label.text = str(currentHealthdisplay) + "%"
	
		# Makes the body deteriorates as it takes damage
		if !is_dead and !is_attacking:
			if currentHealthdisplay >= 50:
				$AnimatedSprite.play("Default")
			elif currentHealthdisplay < 50:
				$AnimatedSprite.play("Cracked")
		if HP <= 0:
			dead()
		
		if is_attacking:
			velocity.x = 0
		# Attack collision flipping
		if !$AnimatedSprite.flip_h:
			get_node("AttackCollision").set_scale(Vector2(1,1))
		else:
			get_node("AttackCollision").set_scale(Vector2(-1,1))	
		
		# Auto movement
		if is_on_floor() and !is_attacking and !is_taking_damage and !jumping:
			velocity.x = SPEED * direction
		if velocity.x > 0:
			$AnimatedSprite.flip_h = false
		else:
			$AnimatedSprite.flip_h = true
		
		if is_shaking:
			shake(1.0)
		if !jumping:
			velocity.y += GRAVITY
		velocity = move_and_slide(velocity , Vector2.UP)
		if is_on_wall() or $RayCast2D.is_colliding():
			direction *= -1
			$RayCast2D.position.x *= -1

func shake(power : float):
	camera.set_offset(Vector2( \
		rand_range(-power, power) * shake, \
		rand_range(-power, power) * shake \
	))



func on_slam():
	is_attacking = true
	double_wave_slam()
	


	

# Double shockwaves 
func double_wave_slam():
	$ShockTimer.start()
	$AnimatedSprite.play("Slam")
	is_attacking = true
	is_shaking = true
	velocity.x = 0
	yield(get_tree().create_timer(1.6), "timeout")
	velocity.x = 0	
	is_attacking = false
	is_shaking = false

func jump():
	jumping = true
	velocity.x = 0
	velocity.y = 0
	yield(get_tree().create_timer(1), "timeout")
	velocity.y += GRAVITY * -2
	yield(get_tree().create_timer(1.5), "timeout")
	velocity.y = 0
	jumping = false

	

func _on_Area2D_area_entered(area):
	if area.is_in_group("Sword") or area.is_in_group("Fireball") and HP > 0:
		is_taking_damage = true
		direction *= -1
		velocity.x = 0
		HP -= 1
		$AnimatedSprite.set_modulate(Color(2,0.5,0.3,1))
		$HurtTimer.start()
		
	if area.is_in_group("Player"):
		direction *= -1
		
func _on_HurtTimer_timeout():
	is_taking_damage = false
	$AnimatedSprite.set_modulate(Color(1,1,1,1))


func _on_ShockTimer_timeout():
	var shockwaveright = SHOCKWAVE.instance()
	var shockwaveleft = SHOCKWAVE.instance()
	get_parent().add_child(shockwaveright)
	get_parent().add_child(shockwaveleft)
	shockwaveright.position = $Position2DRight.global_position
	shockwaveleft.flip_sw(-1)
	shockwaveleft.position = $Position2DLeft.global_position

func send_shockwave(dir : String):
	var shockwave = SHOCKWAVE.instance()
	get_parent().add_child(shockwave)
	match dir:
		"Left":
			shockwave.flip_sw(-1)
			shockwave.position = $Position2DLeft.global_position
		"Right":
			shockwave.position = $Position2DRight.global_position

func _on_GroundTimer_timeout():
	var gpos1 : Position2D = get_parent().get_node("GroundPos1")
	var gpos2 : Position2D = get_parent().get_node("GroundPos2")
	var gpos3 : Position2D = get_parent().get_node("GroundPos3")
	var gpos4 : Position2D = get_parent().get_node("GroundPos4")
	var groundwave1 : Node = GROUNDSHOCKWAVE.instance()
	var groundwave2 : Node = GROUNDSHOCKWAVE.instance()
	get_parent().add_child(groundwave1)
	get_parent().add_child(groundwave2)
	var rng : RandomNumberGenerator = RandomNumberGenerator.new()
	rng.randomize()
	var randint : int = rng.randi_range(0,1)
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

func dead():
	is_dead = true
	$AnimatedSprite.play("Destroyed")
	$Area2D.queue_free()
	$AttackCollision.queue_free()
	$Label.queue_free()


func _on_Left_area_exited(area):
	pass # Replace with function body.


func _on_Right_area_exited(area):
	pass # Replace with function body.


func _on_JumpTimer_timeout():
#	if $Left.overlaps_area(player) or $Right.overlaps_area(player):
	jump()
