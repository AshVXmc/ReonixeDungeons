extends KinematicBody2D

signal life_changed(player_hearts)
signal mana_changed(player_mana)
signal healthpot_obtained(player_healthpot)

onready var inv_timer : Timer = $InvulnerabilityTimer
onready var fb_timer : Timer = $FireballTimer
var knockdir : Vector2 = Vector2.ZERO
var velocity : Vector2 = Vector2(0,0)
var is_attacking : bool = false
var is_dead : bool = false
var is_invulnerable : bool = false
var is_knocked_back : bool = false
var collision : KinematicCollision2D
var collided : bool = false
var healthpot_amount : int = Global.healthpot_amount
var is_dashing : bool = false
var can_dash : bool = false
var dashdirection : Vector2 = Vector2(1,0)
var repulsion : Vector2 = Vector2()
var knockback_power : int = 200

const TYPE : String = "Player"
const SPEED : int = 325
const GRAVITY : int = 45
const JUMP_POWER : int = -1100
const FIREBALL = preload("res://scenes/Fireball.tscn")

func _ready():
	connect("life_changed", get_parent().get_node("HeartUI/Life"), "on_player_life_changed")
	connect("mana_changed", get_parent().get_node("ManaUI/Mana"), "on_player_mana_changed")
	connect("healthpot_obtained", get_parent().get_node("HealthPotUI/HealthPotControl"), "on_player_healthpot_obtained")
	# HP singleton connect
	connect("life_changed", Global, "sync_hearts")
	emit_signal("life_changed", Global.hearts)
	# Mana singleton connect
	connect("mana_changed", Global, "sync_mana")
	emit_signal("mana_changed", Global.mana)
	# Healthpot inventory connect
	connect("healthpot_obtained", Global, "sync_playerHealthpots")
	emit_signal("healthpot_obtained", Global.healthpot_amount)

func _physics_process(_delta):
	# Makes sure the player is alive to use any movement controls
	if !is_dead and !is_invulnerable:
			# Function calls
			attack()
			dash()
			useItems()
			shoot()
			# Movement controls
			if Input.is_action_pressed("right") and !is_attacking and !is_knocked_back:
				velocity.x = SPEED;
				$Sprite.play("Walk")
				$Sprite.flip_h = false
				if sign($Position2D.position.x) == -1:
					$Position2D.position.x *= -1
				if Input.is_action_just_released("right"):
					$Sprite.play("Walk")
				get_node("AttackCollision").set_scale(Vector2(1,1))
			elif Input.is_action_pressed("left") and !is_attacking:
				velocity.x = -SPEED;
				$Sprite.play("Walk")
				$Sprite.flip_h = true
				if sign($Position2D.position.x) == 1:
					$Position2D.position.x *= -1
				get_node("AttackCollision").set_scale(Vector2(-1,1))	
			elif velocity.x == 0:
				if !is_attacking:
					$Sprite.play("Idle")
			# Jump controls
			if Input.is_action_just_pressed("jump") and is_on_floor() and !is_attacking:
				velocity.y = JUMP_POWER
				$Sprite.play("Idle")
				is_attacking = false
				
			# Movement calculations
			velocity.y = velocity.y + GRAVITY
			velocity = move_and_slide(velocity,Vector2.UP)
			velocity.x = lerp(velocity.x,0,0.2)
			if is_invulnerable:
				$Area2D/CollisionShape2D.disabled = true

func useItems():
	if Input.is_action_just_pressed("slot_1"):
			if Global.healthpot_amount > 0:
				Global.healthpot_amount -= 1
				emit_signal("healthpot_obtained", Global.healthpot_amount)
				Global.hearts += Global.max_hearts - Global.hearts
				emit_signal("life_changed", Global.hearts)
				
func shoot():
	if Input.is_action_just_pressed("ui_shoot")	and !is_attacking and Global.mana >= 2:
			var fireball = FIREBALL.instance()
			if sign($Position2D.position.x) == -1:
				fireball.flip_fireball(-1)
			else:
				fireball.flip_fireball(1)	
			get_parent().add_child(fireball)
			fireball.position = $Position2D.global_position
			Global.mana -= 2
			emit_signal("mana_changed", Global.mana)
			is_attacking = false
			$AttackCollision/CollisionShape2D.disabled = true

func attack():
	if Input.is_action_just_pressed("ui_attack") and !is_attacking:
		$Sprite.play("Attack")
		is_attacking = true
		$AttackCollision/CollisionShape2D.disabled = false
		$AttackTimer.start()
		# Upward attack controls
		if Input.is_action_pressed("ui_up"):
			if !$Sprite.flip_h:
				$AttackCollision.position += Vector2(-60,-55)
			else:
				$AttackCollision.position += Vector2(60,-55)	
			$Sprite.play("AttackUp")
			$Sprite.position += Vector2(0, -20)
			is_attacking = true
			$AttackCollision/CollisionShape2D.disabled = false
			$AttackTimer.start()
		# Downwards attack controls + tiny knock-up
		if Input.is_action_pressed("ui_down"):
			if !$Sprite.flip_h:
				$AttackCollision.position += Vector2(-60,55)
			else:
				$AttackCollision.position += Vector2(60,55)	
			$Sprite.play("AttackDown")
			$Sprite.position += Vector2(0, 20)
			is_attacking = true
			$AttackCollision/CollisionShape2D.disabled = false
			$AttackTimer.start()



# Damage and interaction
func _on_Area2D_area_entered(area):
	if area.is_in_group("HealthPot"):
		Global.healthpot_amount += 1
		emit_signal("healthpot_obtained", Global.healthpot_amount)
	if inv_timer.is_stopped():
		if area.is_in_group("Enemy"):
			Global.hearts -= 0.5
			afterDamaged()
			knockback(area.position.x, area.position.y)
		if area.is_in_group("Enemy2"):
			Global.hearts -= 1
			afterDamaged()
			knockback(area.position.x, area.position.y)
	if area.is_in_group("Transporter"):
		emit_signal("level_changed")
	if area.is_in_group("Spike"):
		Global.hearts -= 0.5
		afterDamaged()
		knock_up()

func knock_up():
	if Input.is_action_pressed("ui_down") and is_attacking and $KnockUpTimer.is_stopped():
		velocity.y += 900
		yield(get_tree().create_timer(0.75), "timeout")
		
		


func afterDamaged():
	inv_timer.start() 
	is_invulnerable = true
	emit_signal("life_changed", Global.hearts)
	$Sprite.play("Hurt")
	$KnockbackTimer.start()
	if Global.hearts <= 0:
		dead()

# Obtaining mana by attacking enemies
func _on_AttackCollision_area_entered(area):
	var lootrng : RandomNumberGenerator = RandomNumberGenerator.new()
	lootrng.randomize()
	var randomint = lootrng.randi_range(1,2)
	if area.is_in_group("Enemy") and !$AttackCollision/CollisionShape2D.disabled:
		knock_up()
		if Global.mana < Global.max_mana:
			Global.mana += 1
			emit_signal("mana_changed", Global.mana)
	if area.is_in_group("Enemy2") and !$AttackCollision/CollisionShape2D.disabled:
		knock_up()
		if Global.mana < Global.max_mana:
			Global.mana += randomint
			emit_signal("mana_changed", Global.mana)	
			

func knockback(enemyPos_x : float, enemyPos_y : float):
	# Don't judge my code for this part >:(
	is_knocked_back = true
	if position.x < enemyPos_x and !$Sprite.flip_h:
		velocity.x = 1500
	if position.x > enemyPos_x and !$Sprite.flip_h:
		velocity.x = -1500	
	if position.x > enemyPos_x and $Sprite.flip_h:
		velocity.x = 1500	
	if position.x < enemyPos_x and $Sprite.flip_h:
		velocity.x = -1500

	if position.y < enemyPos_y:
		velocity.y = JUMP_POWER * 0.3
	if position.y > enemyPos_y:
		velocity.y = JUMP_POWER * 0.3
	if !$Sprite.flip_h:
		dashdirection = Vector2(1,0)
	if $Sprite.flip_h:
		dashdirection = Vector2(-1, 0)	
	Input.action_release("left")
	Input.action_release("right")
	Input.action_release("jump")
	Input.action_release("ui_attack")
	Input.action_release("ui_up")
		
func dash():
	if is_on_floor():
		can_dash = true
	if !$Sprite.flip_h:
		dashdirection = Vector2(1,0)
	if $Sprite.flip_h:
		dashdirection = Vector2(-1, 0)		
	if Input.is_action_just_pressed("ui_dash") and Global.mana >= 1 and can_dash:
		velocity.x = 0
		velocity = dashdirection.normalized() * 3500
		can_dash = false
		is_dashing = true
		$DashCooldown.start()
		Global.mana -= 1
		emit_signal("mana_changed", Global.mana)
		is_dashing = false
		Input.action_release("left")
		Input.action_release("right")

			
# Player death	
func dead():
	is_dead = true
	velocity = Vector2(0,0)
	$Sprite.play("Death")
	$CollisionShape2D.disabled = true
	$Timer.start()

# Handles what happens when timers runs out
func _on_Timer_timeout():
	get_tree().change_scene("res://scenes/menus/MainMenu.tscn")
	queue_free() 
	
func _on_InvulnerabilityTimer_timeout():
	is_invulnerable = false
	$Sprite.play("Idle")
	
func _on_AttackTimer_timeout():
	$AttackCollision.position = Vector2(0,0)
	$Sprite.position = Vector2(0,0)
	is_attacking = false
	$AttackCollision/CollisionShape2D.disabled = true
	$Sprite.play("Idle")

func _on_DashCooldown_timeout():
	is_dashing = false
	
func _on_KnockbackTimer_timeout():
	is_knocked_back = false

func _on_KnockUpTimer_timeout():
	pass
