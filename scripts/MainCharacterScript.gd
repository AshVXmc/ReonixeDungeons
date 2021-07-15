extends KinematicBody2D

signal life_changed(player_hearts)
onready var inv_timer : Timer = $InvulnerabilityTimer

var velocity = Vector2(0,0)
var is_attacking : bool = false
var is_dead : bool = false
var is_invulnerable = false

var max_hearts : int = 5
var hearts : int = max_hearts

const SPEED : int = 275
const GRAVITY : int = 45
const JUMP_POWER : int = -1100

func _ready():
	connect("life_changed", get_parent().get_node("HeartUI/Life"), "on_player_life_changed")
	emit_signal("life_changed", max_hearts)
	
func _physics_process(_delta):
	# Makes sure the player is alive to use any movement controls
	if !is_dead and !is_invulnerable:
		# Movement controls
		if Input.is_action_pressed("right") and !is_attacking:
			velocity.x = SPEED;
			$Sprite.play("Walk")
			$Sprite.flip_h = false
			if Input.is_action_just_released("right"):
				$Sprite.play("Walk")
			
			# Collision flipping 
			get_node("AttackCollision").set_scale(Vector2(1,1))
			
		elif Input.is_action_pressed("left") and !is_attacking:
			velocity.x = -SPEED;
			$Sprite.play("Walk")
			$Sprite.flip_h = true
			
			# Collision flipping (Left)
			get_node("AttackCollision").set_scale(Vector2(-1,1))
		elif velocity.x == 0:
			if is_attacking == false:
				  $Sprite.play("Idle")
		
		# Jump controls
		if Input.is_action_just_pressed("jump") and is_on_floor() and !is_attacking:
			velocity.y = JUMP_POWER
			$Sprite.play("Idle")
			is_attacking = false
			
		# Attack controls		
		if Input.is_action_just_pressed("ui_accept") and !is_attacking:
			$Sprite.play("Attack")
			is_attacking = true
			$AttackCollision/CollisionShape2D.disabled = false
			$AttackTimer.start()
		elif Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("left") or Input.is_action_just_pressed("right") or Input.is_action_just_pressed("jump") and is_attacking:
			is_attacking = false
			$AttackCollision/CollisionShape2D.disabled = true	
					
		# Movement calculations
		velocity.y = velocity.y + GRAVITY
		velocity = move_and_slide(velocity,Vector2.UP)
		velocity.x = lerp(velocity.x,0,0.2)
		
		# Player Damage
		damaged()


func damaged():
	if get_slide_count() > 0:
		for i in range(get_slide_count()):
			if "Enemy" in get_slide_collision(i).collider.name and inv_timer.is_stopped():
				inv_timer.start() 
				is_invulnerable = true
				hearts -= 1
				emit_signal("life_changed", hearts)
				$Sprite.play("Hurt")
				
				if hearts <= 0:
					dead()
					
func dead():
	is_dead = true
	velocity = Vector2(0,0)
	$Sprite.play("Death")
	$CollisionShape2D.disabled = true
	$Timer.start()
		
# Handles what happens when timers runs out
func _on_Timer_timeout():
	get_tree().change_scene("res://scenes/MainMenu.tscn") 
	
func _on_InvulnerabilityTimer_timeout():
	is_invulnerable = false
	
func _on_AttackTimer_timeout():
	is_attacking = false
