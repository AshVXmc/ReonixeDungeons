extends KinematicBody2D

var velocity = Vector2()
var HP = 2
var direction : int = 1
var is_dead : bool = false 
const TYPE : String = "Enemy"
const FLOOR = Vector2(0, -1)
const SPEED : int = 100
const GRAVITY : int = 45
const LOOT : PackedScene = preload("res://scenes/items/HealthPot.tscn")
var rng : RandomNumberGenerator = RandomNumberGenerator.new()

func _physics_process(delta):
	velocity.x = SPEED * direction
	if direction == 1 and !is_dead:
		$AnimatedSprite.flip_h = false
	elif !is_dead:
		$AnimatedSprite.flip_h = true
	
	if !is_dead:	
		$AnimatedSprite.play("slimeanim")
	
	velocity.y += GRAVITY
	velocity = move_and_slide(velocity, FLOOR)
	
	if is_on_wall() or !$RayCast2D.is_colliding():
		direction *= -1
		$RayCast2D.position.x *= -1
	
	

func _on_Area2D_area_entered(area):
	if area.is_in_group("Sword") and HP > 0:
		HP -= 1
		set_modulate(Color(2,0.5,0.3,1))
		velocity.x = 0
		$HurtTimer.start()
	elif area.is_in_group("Fireball") and HP > 0:
		HP -= 1
		set_modulate(Color(2,0.5,0.3,1))
		velocity.x = 0
		$HurtTimer.start()
	var loot = LOOT.instance()
	var lootrng : RandomNumberGenerator = RandomNumberGenerator.new()
	lootrng.randomize()
	var randomint = lootrng.randi_range(1,5)
	print(randomint)	
	if HP <= 0:
		if randomint == 1:
			get_parent().add_child(loot)
			loot.position = $Position2D.global_position
		queue_free()

func _on_HurtTimer_timeout():
	velocity.x = SPEED * direction
	set_modulate(Color(1,1,1,1))
