class_name Player extends KinematicBody2D

signal life_changed(player_hearts)
signal mana_changed(player_mana)
signal healthpot_obtained(player_healthpot)
signal lifewine_obtained(player_lifewine)
signal manapot_obtained(player_manapot)
signal opals_obtained(player_opals)

onready var inv_timer : Timer = $InvulnerabilityTimer
onready var fb_timer : Timer = $FireballTimer
var knockdir : Vector2 = Vector2.ZERO
var velocity : Vector2 = Vector2(0,0)
var healthpot_amount : int = Global.healthpot_amount
var collision : KinematicCollision2D
const TYPE : String = "Player"
var dashdirection : Vector2 = Vector2(1,0)
var repulsion : Vector2 = Vector2()
var knockback_power : int = 200
var can_be_knocked : bool = true
const SPEED : int = 380
const GRAVITY : int = 40
const JUMP_POWER : int = -1075
const FIREBALL : PackedScene = preload("res://scenes/Fireball.tscn")

var is_attacking : bool = false
var is_dead : bool = false
var is_invulnerable : bool = false
var is_knocked_back : bool = false
var collided : bool = false
var is_dashing : bool = false
var is_gliding : bool = false
var can_dash : bool = false
var is_healing : bool = false
var is_shopping : bool = false

func _ready():
		# warning-ignore:return_value_discarded
	connect("life_changed", get_parent().get_node("HeartUI/Life"), "on_player_life_changed")
# warning-ignore:return_value_discarded
	connect("mana_changed", get_parent().get_node("ManaUI/Mana"), "on_player_mana_changed")
# warning-ignore:return_value_discarded
	connect("healthpot_obtained", get_parent().get_node("HealthPotUI/HealthPotControl"), "on_player_healthpot_obtained")
# warning-ignore:return_value_discarded
	connect("lifewine_obtained", get_parent().get_node("LifeWineUI/LifeWineControl"), "on_player_lifewine_obtained")
	connect("manapot_obtained", get_parent().get_node("ManaPotUI/ManaPotControl"), "on_player_manapot_obtained")
	connect("opals_obtained", get_parent().get_node("OpalsUI/OpalsControl"), "on_player_opals_obtained")
	# HP singleton connect
# warning-ignore:return_value_discarded
	connect("life_changed", Global, "sync_hearts")
	emit_signal("life_changed", Global.hearts)
	# Mana singleton connect
# warning-ignore:return_value_discarded
	connect("mana_changed", Global, "sync_mana")
	emit_signal("mana_changed", Global.mana)
	# Healthpot inventory connect
# warning-ignore:return_value_discarded
	connect("healthpot_obtained", Global, "sync_playerHealthpots")
	emit_signal("healthpot_obtained", Global.healthpot_amount)
	# Lifewine inventory connect
# warning-ignore:return_value_discarded
	connect("lifewine_obtained", Global, "sync_playerLifeWines")
	emit_signal("lifewine_obtained", Global.lifewine_amount)
	
	connect("manapot_obtained", Global, "sync_playerManapots")
	emit_signal("manapot_obtained", Global.manapot_amount)
	
	connect("opals_obtained", Global, "sync_playerOpals")
	emit_signal("opals_obtained", Global.opals_amount)

func _physics_process(_delta):
	# Makes sure the player is alive to use any movement controls
	if !is_dead and !is_invulnerable and !is_healing:
		# Function calls
		attack()
		dash()
		glide() # Glide duration in seconds
		useItems()
		shoot()
		# Movement controls
		if velocity.x == 0 and !is_attacking and !is_gliding:
			$Sprite.play("Idle")
		if Input.is_action_pressed("right") and !is_attacking and !is_knocked_back:
			velocity.x = SPEED
			$Sprite.play("Glide") if is_gliding else $Sprite.play("Walk")
			$Sprite.flip_h = false
			if velocity.x == 0 and !is_attacking:
				$Sprite.play("Idle")
			if sign($Position2D.position.x) == -1:
				$Position2D.position.x *= -1
			if Input.is_action_just_released("right"):
				$Sprite.play("Walk")
			get_node("AttackCollision").set_scale(Vector2(1,1))
		elif Input.is_action_pressed("left") and !is_attacking:
			velocity.x = -SPEED
			$Sprite.play("Glide") if is_gliding else $Sprite.play("Walk")
			$Sprite.flip_h = true
			if velocity.x == 0 and !is_attacking:
				$Sprite.play("Idle")
			if sign($Position2D.position.x) == 1:
				$Position2D.position.x *= -1
			get_node("AttackCollision").set_scale(Vector2(-1,1))	
		elif velocity.x == 0:
			if !is_attacking:
				$Sprite.play("Idle")
			if is_gliding and Global.glide_unlocked:
				$Sprite.play("Glide")
		# Jump controls
		if Input.is_action_just_pressed("jump") and is_on_floor() and !is_attacking:
			velocity.y = JUMP_POWER
			$Sprite.play("Idle")
			is_attacking = false
			
		# Movement calculations
		if !is_dashing and !is_gliding:
			velocity.y += GRAVITY
		velocity = move_and_slide(velocity,Vector2.UP)
		velocity.x = lerp(velocity.x,0,0.2)
		if is_invulnerable:
			$Area2D/CollisionShape2D.disabled = true
			
		if Input.is_action_just_pressed("ui_use"):
			$ToggleArea/CollisionShape2D.disabled = false
			yield(get_tree().create_timer(0.4), "timeout")
			$ToggleArea/CollisionShape2D.disabled = true
				
	if is_healing:
		$Sprite.play("Healing")
			
func shoot():
	if Input.is_action_just_pressed("ui_shoot")	and !is_attacking and Global.mana >= 1:
			var fireball = FIREBALL.instance()
			fireball.flip_fireball(-1) if sign($Position2D.position.x) == -1 else fireball.flip_fireball(1)	
			get_parent().add_child(fireball)
			fireball.position = $Position2D.global_position
			Global.mana -= 1
			emit_signal("mana_changed", Global.mana)
			is_attacking = false
			$AttackCollision/CollisionShape2D.disabled = true

func attack():
	if Input.is_action_just_pressed("ui_attack") and !is_attacking and !is_gliding:
		$Sprite.play("Attack")
		is_attacking = true
		$AttackCollision/CollisionShape2D.disabled = false
		$AttackTimer.start()
		# Upward attack controls
		if Input.is_action_pressed("ui_up"):
			$AttackCollision.position += Vector2(-60,-55) if !$Sprite.flip_h else Vector2(60,-55)
			$Sprite.play("AttackUp")
			$Sprite.position += Vector2(0, -20)
			is_attacking = true
			$AttackCollision/CollisionShape2D.disabled = false
			$AttackTimer.start()
		# Downwards attack controls + tiny knock-up
		if Input.is_action_pressed("ui_down"):
			$AttackCollision.position += Vector2(-60,55) if !$Sprite.flip_h else Vector2(60,55)
			$Sprite.play("AttackDown")
			$Sprite.position += Vector2(0, 20)
			is_attacking = true
			$AttackCollision/CollisionShape2D.disabled = false
			$AttackTimer.start()

# Damage and interaction
func _on_Area2D_area_entered(area : Area2D):
#	if area.is_in_group("Campfire"):
#		Global.hearts += Global.max_hearts - Global.hearts
	if area.is_in_group("HealthPot"):
		Global.healthpot_amount += 1
		emit_signal("healthpot_obtained", Global.healthpot_amount)
	if area.is_in_group("LifeWine"):
		Global.lifewine_amount += 1
		emit_signal("lifewine_obtained", Global.lifewine_amount)
	if inv_timer.is_stopped():
		if area.is_in_group("Enemy"):
			Global.hearts -= 0.5
			afterDamaged()
			knockback()
		if area.is_in_group("Enemy2"):
			Global.hearts -= 1
			afterDamaged()
			knockback()
	if area.is_in_group("Transporter"):
		emit_signal("level_changed")
	if area.is_in_group("Spike"):
		Global.hearts -= 0.5
		afterDamaged()


func attack_knock():
	var KNOCK_POWER : int = 175
	velocity.x = -KNOCK_POWER if !$Sprite.flip_h else KNOCK_POWER

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
	if area.is_in_group("CoffeeMachine"):
		Global.hearts += Global.max_hearts - Global.hearts
		Global.mana += Global.max_mana - Global.mana
		emit_signal("life_changed", Global.hearts)
		emit_signal("mana_changed", Global.mana)
	var lootrng : RandomNumberGenerator = RandomNumberGenerator.new()
	lootrng.randomize()
	var randomint = lootrng.randi_range(1,2)
	if area.is_in_group("Enemy") or area.is_in_group("Enemy2") and !$AttackCollision/CollisionShape2D.disabled:
		attack_knock()
		if Global.mana < Global.max_mana:
			Global.mana += randomint
			emit_signal("mana_changed", Global.mana)
			

func knockback():
	# Don't judge my code for this part >:(
	if can_be_knocked:
		$KnockbackCooldownTimer.start()
		is_knocked_back = true
		can_be_knocked = false
	dashdirection = Vector2(-1, 0) if $Sprite.flip_h else Vector2(1,0)
	Input.action_release("jump")
	Input.action_release("ui_attack")
	Input.action_release("ui_up")

func _on_LeftDetector_area_entered(area):
	if area.is_in_group("Enemy") or area.is_in_group("Enemy2") and is_knocked_back:
		velocity.x = 1500
		$KnockbackCooldownTimer.start()
		velocity.y = JUMP_POWER * 0.25
		is_healing = false
		$HealingTimer.stop()
func _on_RightDectector_area_entered(area):
	if area.is_in_group("Enemy") or area.is_in_group("Enemy2") and is_knocked_back:
		velocity.x = -1500
		$KnockbackCooldownTimer.start()
		velocity.y = JUMP_POWER * 0.25
func dash():
	if Global.dash_unlocked:
		if is_on_floor() and $DashUseTimer.is_stopped():
			can_dash = true
		if !$Sprite.flip_h:
			dashdirection = Vector2(1,0)
		if $Sprite.flip_h:
			dashdirection = Vector2(-1, 0)		
		if Input.is_action_just_pressed("ui_dash") and can_dash and $DashUseTimer.is_stopped() and Global.mana > 0:
			Global.mana -= 1
			emit_signal("mana_changed", Global.mana)
			can_dash = false
			$DashUseTimer.start()
			$Sprite.play("Dash")
			velocity.x = 0
			velocity.y = 0
			velocity = dashdirection.normalized() * 3000
			can_dash = false
			is_dashing = true
			yield(get_tree().create_timer(0.25), "timeout")
			$DashCooldown.start()
			velocity.y += GRAVITY
			is_dashing = false
			Input.action_release("left")
			Input.action_release("right")

func glide():
	# Press SPACE while in mid-air to temporarily glide
	if Global.glide_unlocked and Input.is_action_just_pressed("jump") and !is_on_floor() and Global.mana >= 3:
		if is_on_floor():
			is_gliding = false

		is_gliding = true
		if is_gliding:	
			$Sprite.play("Glide")
		velocity.y = 0
		velocity.y += GRAVITY
		Global.mana -= 3
		emit_signal("mana_changed", Global.mana)
		if Input.is_action_just_released("jump"):
			is_gliding = false
			velocity.y += GRAVITY * 2
		yield(get_tree().create_timer(1), "timeout")
		is_gliding = false
		Input.action_release("jump")


func useItems():
	# Health potions
	if Input.is_action_just_pressed("slot_1") and Global.hearts < Global.max_hearts and Global.healthpot_amount > 0:
		heal_player("HealthPot")
	# Life wines (Increase maximum health)
	elif Input.is_action_just_pressed("slot_2") and Global.hearts < Global.max_hearts and Global.lifewine_amount > 0:
		heal_player("LifeWine")
	elif Input.is_action_just_pressed("slot_3") and Global.mana < Global.max_mana and Global.manapot_amount > 0: 
		heal_player("ManaPot")

func heal_player(item : String):
	if !is_healing:
		is_healing = true
		match item:
			"HealthPot":
				$HealingTimer.start()
				if $Area2D.is_in_group("Enemy") or $Area2D.is_in_group("Enemy2"):
					$HealingTimer.stop()
					is_healing = false
			"LifeWine":
				$FullHealTimer.start()
				if $Area2D.is_in_group("Enemy") or $Area2D.is_in_group("Enemy2"):
					$FullHealTimer.stop()
					is_healing = false
			"ManaPot":
				$ManaHealTimer.start()
				if $Area2D.is_in_group("Enemy") or $Area2D.is_in_group("Enemy2"):
					$ManaHealTimer.stop()
					is_healing = false
	Input.action_release("left")
	Input.action_release("right")

# Player death	
func dead():
	is_dead = true
	velocity = Vector2(0,0)
	$Sprite.play("Death")
	$CollisionShape2D.disabled = true
	$Timer.start()

func on_campfire_toggled():
	Global.hearts += Global.max_hearts - Global.hearts
	emit_signal("life_changed", Global.hearts)
	
func on_lootbag_obtained():
	var lootrng : RandomNumberGenerator = RandomNumberGenerator.new()
	var opalrng : RandomNumberGenerator = RandomNumberGenerator.new()
	lootrng.randomize()
	opalrng.randomize()
	var num  = lootrng.randi_range(1,10)
	var opalnum = opalrng.randi_range(5,10)
	if num <= 4:
		Global.healthpot_amount += 1
		emit_signal("healthpot_obtained", Global.healthpot_amount)
	elif num >= 5 and num <= 8:
		pass
		Global.manapot_amount += 1
		emit_signal("manapot_obtained", Global.manapot_amount)
	else:
		Global.lifewine_amount += 1
		emit_signal("lifewine_obtained", Global.lifewine_amount)
		
	Global.opals_amount += opalnum
	emit_signal("opals_obtained", Global.opals_amount)
		

func on_Item_bought(item_name : String, item_price : int):
	Global.opals_amount -= item_price
	emit_signal("opals_obtained", Global.opals_amount)
	match item_name:
		"HealthPot":
			Global.healthpot_amount += 1
			emit_signal("healthpot_obtained", Global.healthpot_amount)
	

# Handles what happens when timers runs out
func _on_Timer_timeout():
# warning-ignore:return_value_discarded
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
	$Sprite.play("Idle")
	
func _on_KnockbackTimer_timeout():
	is_knocked_back = false
	repulsion.x = knockback_power
	velocity.x = 0

func _on_KnockbackCooldownTimer_timeout():
	can_be_knocked = true
	Input.action_release("left")
	Input.action_release("right")

func _on_DashUseTimer_timeout():
	can_dash = true 

func _on_HealingTimer_timeout():
	is_healing = false
	if Global.healthpot_amount > 0:
		if Global.max_hearts - Global.hearts == 0.5:
			Global.hearts += 0.5
		else:
			Global.hearts += 1
		emit_signal("life_changed", Global.hearts)
		Global.healthpot_amount -= 1
		emit_signal("healthpot_obtained", Global.healthpot_amount)

func _on_FullHealTimer_timeout():
	is_healing = false
	if Global.lifewine_amount > 0 and Global.hearts < Global.max_hearts:
		Global.hearts += Global.max_hearts - Global.hearts
		emit_signal("life_changed", Global.hearts)
		Global.lifewine_amount -= 1
		emit_signal("lifewine_obtained", Global.lifewine_amount)

func _on_ManaHealTimer_timeout():
	is_healing = false
	if Global.manapot_amount > 0 and Global.mana < Global.max_mana:
		Global.mana += Global.max_mana - Global.mana
		emit_signal("mana_changed", Global.mana)
		Global.manapot_amount -= 1
		emit_signal("manapot_obtained", Global.manapot_amount)
