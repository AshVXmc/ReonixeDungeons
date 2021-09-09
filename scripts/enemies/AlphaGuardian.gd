extends KinematicBody2D

const TYPE : String = "Enemy"
const SPEED : int = 285
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
var is_attacking : bool = false
var is_taking_damage : bool = false
var is_jumping : bool = false
export var maxHP : float = 34
export var HP : float = 34

# ATTACK PATTERNS
# Sends shockwaves on two directions while is on floor.
# Summons stalagmite-like spikes  

func _ready():
	$AttackTimer.start()

func _on_AttackTimer_timeout():
	downwards_slam()


func _process(_delta):
	# Healthbar (rounded up floats)
	var currentHealthdisplay : int = int(ceil((HP / maxHP) * 100))
	$Label.text = str(currentHealthdisplay) + "%"

	# Label color update
	# 50% - 100% = Green, 20% - 50% = Yellow, 1% - 20% red
	# doesn't work for some reason
	if currentHealthdisplay <= 100 and currentHealthdisplay >= 50:
		# GREEN
		get_node("Label").set("font_color",Color(16,227,48))
	elif currentHealthdisplay <= 49 and currentHealthdisplay >= 20:
		# YELLOW
		get_node("Label").set("font_color",Color(227,206,16))
	elif currentHealthdisplay <= 19 and currentHealthdisplay > 0:
		# RED
		get_node("Label").set("font_color",Color(214,13,13))

func _physics_process(_delta):
	if !is_dead:
		if velocity.x == SPEED:
			$AnimatedSprite.flip_h = false
		elif velocity.x == -SPEED:
			$AnimatedSprite.flip_h = true	
	if HP <= 0:
		queue_free()
	# attack collision flipping
	if !$AnimatedSprite.flip_h:
		get_node("AttackCollision").set_scale(Vector2(1,1))
	else:
		get_node("AttackCollision").set_scale(Vector2(-1,1))	
	if velocity.x > 0 or velocity.x < 0 and !is_dead and !is_attacking:
		$AnimatedSprite.play("Default")
	if is_on_floor() and !is_attacking and !is_taking_damage:
		velocity.x = SPEED * direction
	velocity.y += GRAVITY
	velocity = move_and_slide(velocity , Vector2.UP)

#	if $Left.overlaps_area(player):
#		yield(get_tree().create_timer(0.8),"timeout")
#		direction *= -1
#	if $Right.overlaps_area(player):
#		yield(get_tree().create_timer(0.8),"timeout")
#		direction *= 1
	if is_on_wall() or $RayCast2D.is_colliding():
		direction *= -1
		$RayCast2D.position.x *= -1

func melee_attack():
	var playerposx : Node = get_parent().get_node("Player")
	is_attacking = true
	yield(get_tree().create_timer(1.25), "timeout")
	$AttackCollision/CollisionPolygon2D.disabled = false
	# Jumping
#	velocity.y += -2200
	if !$AnimatedSprite.flip_h:
#		$CollisionPolygon2D.position.x = -38.098
#		$CollisionPolygon2D.position.y = -0.794
		$Area2D/CollisionPolygon2D.position.x = -38.098
		$Area2D/CollisionPolygon2D.position.y = -0.794
	else:
#		$CollisionPolygon2D.position.x = 62.702
#		$CollisionPolygon2D.position.y = -0.794
		$Area2D/CollisionPolygon2D.position.x = 62.702
		$Area2D/CollisionPolygon2D.position.y = -0.794
	yield(get_tree().create_timer(1), "timeout")
#	velocity.x = SPEED * direction
	$AttackCollision/CollisionPolygon2D.disabled = true
	# default coordinates
#	$CollisionPolygon2D.position.x = 7.937
#	$CollisionPolygon2D.position.y = 0
	$Area2D/CollisionPolygon2D.position.x = 7.937
	$Area2D/CollisionPolygon2D.position.y = 0
	is_attacking = false	
		

# Teleports upward and slams downwards (from one of the three pillar spots)
# Note: test this on the Level scene so it doesn't produce a null instance error (Position nodes)
func downwards_slam():
	is_attacking = true
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
			stalagmite_smash()
			
func idle_smash():
	pass

# Smacks club to ground and four shockwaves come up from four spots
func stalagmite_smash():
	$MeleeTimer.stop()
	$GroundTimer.start()
	velocity.x = 0
	$JumpTimer.start()
	$AnimatedSprite.play("Slam")
	is_attacking = true
	yield(get_tree().create_timer(1), "timeout")
	is_attacking = false
	$MeleeTimer.start()

# Double shockwaves go brrrrr skiddy bip dop click dip bop SKREEE MEEEEP
func double_wave_slam():
	$MeleeTimer.stop()
	$ShockTimer.start()
	$AnimatedSprite.play("Slam")
	is_attacking = true
	velocity.x = 0
	yield(get_tree().create_timer(1.6), "timeout")
	velocity.x = 0	
	is_attacking = false
	$MeleeTimer.start()

func _on_Area2D_area_entered(area):
	if area.is_in_group("Sword") or area.is_in_group("Fireball") and HP > 0:
		is_taking_damage = true
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

func _on_JumpTimer_timeout():
	is_jumping = false
