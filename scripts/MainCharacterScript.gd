extends KinematicBody2D

signal life_changed(player_hearts)
signal mana_changed(player_mana)
signal healthpot_obtained(player_healthpot)

onready var inv_timer : Timer = $InvulnerabilityTimer
onready var fb_timer : Timer = $FireballTimer
var velocity : Vector2 = Vector2(0,0)
var is_attacking : bool = false
var is_dead : bool = false
var is_invulnerable = false
var collision : KinematicCollision2D
var collided : bool = false

var max_hearts : float = 5
var hearts : float = max_hearts
var max_mana : float = 3
var mana : float = max_mana
var healthpot_amount : int = 0

const TYPE : String = "Player"
const SPEED : int = 275
const GRAVITY : int = 45
const JUMP_POWER : int = -1100
const FIREBALL = preload("res://scenes/Fireball.tscn")

func _ready():
	connect("life_changed", get_parent().get_node("HeartUI/Life"), "on_player_life_changed")
	connect("mana_changed", get_parent().get_node("ManaUI/Mana"), "on_player_mana_changed")
	connect("healthpot_obtained", get_parent().get_node("HealthPotUI/HealthPotControl"), "on_player_healthpot_obtained")
	emit_signal("life_changed", max_hearts)
	emit_signal("mana_changed", max_mana)	
	emit_signal("healthpot_obtained", healthpot_amount)

func _physics_process(_delta):
	# Makes sure the player is alive to use any movement controls
	if !is_dead and !is_invulnerable:
		# Movement controls
		if Input.is_action_pressed("right") and !is_attacking:
			velocity.x = SPEED;
			$Sprite.play("Walk")
			$Sprite.flip_h = false
			if sign($Position2D.position.x) == -1:
				$Position2D.position.x *= -1
			if Input.is_action_just_released("right"):
				$Sprite.play("Walk")
			
			# Collision flipping 
			get_node("AttackCollision").set_scale(Vector2(1,1))
			
		elif Input.is_action_pressed("left") and !is_attacking:
			velocity.x = -SPEED;
			$Sprite.play("Walk")
			$Sprite.flip_h = true
			if sign($Position2D.position.x) == 1:
				$Position2D.position.x *= -1
			
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
			
		if Input.is_action_just_pressed("ui_shoot")	and !is_attacking and mana > 0:
			var fireball = FIREBALL.instance()
			if sign($Position2D.position.x) == -1:
				fireball.flip_fireball(-1)
			else:
				fireball.flip_fireball(1)	
			get_parent().add_child(fireball)
			fireball.position = $Position2D.global_position
			
			mana -= 0.5
			emit_signal("mana_changed", mana)
			
			is_attacking = false
			$AttackCollision/CollisionShape2D.disabled = true
			
			if mana <= max_mana:
				$FireballTimer.start()
				
		if Input.is_action_just_pressed("ui_heal"):
			if healthpot_amount > 0:
				healthpot_amount -= 1
				emit_signal("healthpot_obtained", healthpot_amount)
				hearts += max_hearts - hearts
				
				hearts += max_hearts - hearts
				emit_signal("life_changed", hearts)	
				
			
		# Attack controls		
		if Input.is_action_just_pressed("ui_attack") and !is_attacking:
			$Sprite.play("Attack")
			is_attacking = true
			$AttackCollision/CollisionShape2D.disabled = false
			$AttackTimer.start()
		elif Input.is_action_just_pressed("ui_attack") or Input.is_action_just_pressed("left") or Input.is_action_just_pressed("right") or Input.is_action_just_pressed("jump") or Input.is_action_just_pressed("ui_shoot") and is_attacking:
			is_attacking = false
			$AttackCollision/CollisionShape2D.disabled = true	
					
		# Movement calculations
		velocity.y = velocity.y + GRAVITY
		velocity = move_and_slide(velocity,Vector2.UP)
		velocity.x = lerp(velocity.x,0,0.2)
		
		if is_invulnerable == true:
			$Area2D/CollisionShape2D.disabled = true


func _on_Area2D_area_entered(area):
	if area.is_in_group("HealthPot"):
		healthpot_amount += 1
		emit_signal("healthpot_obtained", healthpot_amount)
	if inv_timer.is_stopped():
		if area.is_in_group("Enemy"):
			inv_timer.start() 
			is_invulnerable = true
			hearts -= 0.5
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
	get_tree().change_scene("res://scenes/menus/MainMenu.tscn") 
	
func _on_InvulnerabilityTimer_timeout():
	is_invulnerable = false
	$Sprite.play("Idle")
	
func _on_AttackTimer_timeout():
	is_attacking = false
	$AttackCollision/CollisionShape2D.disabled = true	
	

func _on_FireballTimer_timeout():
	if mana < max_mana:
		mana += 0.5
		$FireballTimer.start()
	emit_signal("mana_changed", mana)

