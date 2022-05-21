class_name Player extends KinematicBody2D

signal life_changed(player_hearts)
signal mana_changed(player_mana)
signal healthpot_obtained(player_healthpot)
signal lifewine_obtained(player_lifewine)
signal manapot_obtained(player_manapot)
signal opals_obtained(player_opals)
signal crystals_obtained(player_crystals)
signal common_monster_dust_obtained(player_common_monster_dust)
signal goblin_scales_obtained(player_goblin_scales)

onready var inv_timer : Timer = $InvulnerabilityTimer
onready var fb_timer : Timer = $FireballTimer
var knockdir : Vector2 = Vector2.ZERO
var velocity : Vector2 = Vector2(0,0)
var healthpot_amount : int = Global.healthpot_amount
var collision : KinematicCollision2D
const TYPE : String = "Player"
var dashdirection : Vector2 = Vector2(1,0)
var repulsion : Vector2 = Vector2()
var knockback_power : int = 150
var can_be_knocked : bool = true
var SPEED : int = 380
const GRAVITY : int = 40
var JUMP_POWER : int = -1075
const FIREBALL : PackedScene = preload("res://scenes/misc/Fireball.tscn")
const FIRESAW : PackedScene = preload("res://scenes/misc/FireSaw.tscn")
const JUMP_PARTICLE : PackedScene = preload("res://scenes/particles/JumpParticle.tscn")
const DASH_PARTICLE : PackedScene = preload("res://scenes/particles/DashParticle.tscn")
const SWORD_PARTICLE : PackedScene = preload("res://scenes/particles/SwordSwingParticle.tscn")
const FIRE_PARTICLE : PackedScene = preload("res://scenes/particles/FlameParticle.tscn")
const GROUND_POUND_PARTICLE : PackedScene = preload("res://scenes/particles/GroundPoundParticle.tscn")
const SUPER_SLASH_PROJECTILE : PackedScene = preload("res://scenes/misc/SuperSlashProjectile.tscn")
onready var FULL_CHARGE_METER = preload("res://assets/UI/chargebar_full.png")
onready var CHARGING_CHARGE_METER = preload("res://assets/UI/chargebar_charging.png")
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
var is_frozen : bool = false
var is_using_firesaw : bool = false
var glider_equipped : bool = false
var is_ground_pounding : bool = false
var cam_shake : bool = false
var is_charging : bool = false
var slowed : bool = false


func _ready():
	$ChargeBar.value = 0
	$SwordSprite.visible = false
	$ChargeBar.visible = false
# warning-ignore:return_value_discarded
	connect("life_changed", get_parent().get_node("HeartUI/Life"), "on_player_life_changed")
# warning-ignore:return_value_discarded
	connect("mana_changed", get_parent().get_node("ManaUI/Mana"), "on_player_mana_changed")
# warning-ignore:return_value_discarded
	connect("healthpot_obtained", get_parent().get_node("HealthPotUI/HealthPotControl"), "on_player_healthpot_obtained")
# warning-ignore:return_value_discarded
	connect("lifewine_obtained", get_parent().get_node("LifeWineUI/LifeWineControl"), "on_player_lifewine_obtained")
# warning-ignore:return_value_discarded
	connect("manapot_obtained", get_parent().get_node("ManaPotUI/ManaPotControl"), "on_player_manapot_obtained")
# warning-ignore:return_value_discarded
	connect("opals_obtained", get_parent().get_node("OpalsUI/OpalsControl"), "on_player_opals_obtained")
# warning-ignore:return_value_discarded
	connect("crystals_obtained", get_parent().get_node("RevivementCrystal/RevivementCrystalControl"), "on_player_crystal_obtained")
	connect("common_monster_dust_obtained", get_parent().get_node("CommonMonsterDustUI/CommonMonsterDust"), "on_player_common_monster_dust_obtained")
	connect("goblin_scales_obtained", get_parent().get_node("GoblinScalesUI/GoblinScales"), "on_player_goblin_scales_obtained")
# warning-ignore:return_value_discarded
	connect("life_changed", Global, "sync_hearts")
	emit_signal("life_changed", Global.hearts)
# warning-ignore:return_value_discarded
	connect("mana_changed", Global, "sync_mana")
	emit_signal("mana_changed", Global.mana)
# warning-ignore:return_value_discarded
	connect("healthpot_obtained", Global, "sync_playerHealthpots")
	emit_signal("healthpot_obtained", Global.healthpot_amount)
# warning-ignore:return_value_discarded
	connect("lifewine_obtained", Global, "sync_playerLifeWines")
	emit_signal("lifewine_obtained", Global.lifewine_amount)
# warning-ignore:return_value_discarded
	connect("manapot_obtained", Global, "sync_playerManapots")
	emit_signal("manapot_obtained", Global.manapot_amount)
# warning-ignore:return_value_discarded
	connect("opals_obtained", Global, "sync_playerOpals")
	emit_signal("opals_obtained", Global.opals_amount)
# warning-ignore:return_value_discarded
	connect("crystals_obtained", Global, "sync_playerCrystals")
	emit_signal("crystals_obtained", Global.crystals_amount)
	
	connect("common_monster_dust_obtained", Global, "sync_playerCommonMonsterDust")
	emit_signal("common_monster_dust_obtained", Global.common_monster_dust_amount)
	
	connect("goblin_scales_obtained", Global, "sync_playerGoblinScales")
	emit_signal("goblin_scales_obtained", Global.goblin_scales_amount)
func _physics_process(_delta):
	# Makes sure the player is alive to use any movement controls
	if !is_dead and !is_invulnerable and !is_healing and !is_shopping and !is_frozen:
		# Function calls
		attack()
		if !is_charging:
			dash()
			glide() # Glide duration in seconds
			useItems()
			shoot()
			ground_pound()
			# Movement controls
			if velocity.x == 0 and !is_attacking and !is_gliding and !is_frozen:
				$Sprite.play("Idle")
			if Input.is_action_pressed("right") and !is_attacking and !is_knocked_back:
				velocity.x = SPEED
			# warning-ignore:standalone_ternary
				$Sprite.play("Glide") if is_gliding else $Sprite.play("Walk")
				$Sprite.flip_h = false
				if velocity.x == 0 and !is_attacking and is_gliding:
					$Sprite.play("Idle")
				if sign($Position2D.position.x) == -1:
					$Position2D.position.x *= -1
				if sign($DashParticlePosition.position.x) == 1:
					$DashParticlePosition.position.x *= -1
				if Input.is_action_just_released("right"):
					$Sprite.play("Walk")
				get_node("AttackCollision").set_scale(Vector2(1,1))
			elif Input.is_action_pressed("left") and !is_attacking:
				velocity.x = -SPEED
	# warning-ignore:standalone_ternary
				$Sprite.play("Glide") if is_gliding else $Sprite.play("Walk")
				$Sprite.flip_h = true
				if velocity.x == 0 and !is_attacking and !is_gliding:
					$Sprite.play("Idle")
				if sign($Position2D.position.x) == 1:
					$Position2D.position.x *= -1
				if sign($DashParticlePosition.position.x) == -1:
					$DashParticlePosition.position.x *= -1
				get_node("AttackCollision").set_scale(Vector2(-1,1))	
			elif velocity.x == 0:
				if !is_attacking:
					$Sprite.play("Idle")
				if is_gliding and Global.glide_unlocked:
					$Sprite.play("Glide")
			# Jump controls
			if Input.is_action_just_pressed("jump") and is_on_floor() and !is_attacking and !is_frozen:
				# Particles
				var jump_particle : JumpParticle = JUMP_PARTICLE.instance()
				jump_particle.emitting = true
				get_parent().add_child(jump_particle)
				jump_particle.position = $ParticlePosition.global_position
				
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
				yield(get_tree().create_timer(1), "timeout")
				$ToggleArea/CollisionShape2D.disabled = true
	if is_healing:
		$Sprite.play("Healing")
	if is_frozen:
		$Sprite.play("Frozen")
	$FreezeMask.visible = true if is_frozen else false
	if glider_equipped and !is_gliding:
		$GliderWings.visible = true
	if !glider_equipped or is_gliding:
		$GliderWings.visible = false
	if is_gliding:
		$Sprite.play("Glide")
		$GliderWings.visible = false
	if cam_shake:
		$Camera2D.set_offset(Vector2( \
			rand_range(-1, 1) * 3, \
			rand_range(-1, 1) * 3 \
		))
	charge_meter()

	


func shoot():
	if Input.is_action_just_pressed("ui_shoot")	and !is_attacking and !is_frozen and Global.mana >= 1:
			var fireball : Fireball = FIREBALL.instance()
			# warning-ignore:standalone_ternary
			fireball.flip_projectile(-1) if sign($Position2D.position.x) == -1 else fireball.flip_projectile(1)	
			get_parent().add_child(fireball)
			fireball.position = $Position2D.global_position
			if !Global.godmode:
				Global.mana -= 1
				emit_signal("mana_changed", Global.mana)
			is_attacking = false
			$AttackCollision/CollisionShape2D.disabled = true
	
	if Input.is_action_just_pressed("firesaw") and Global.firesaw_unlocked and !is_attacking and !is_frozen and Global.mana >= 3 and !is_using_firesaw:
		is_using_firesaw = true
		var firesaw = FIRESAW.instance()
		var fireparticle = FIRE_PARTICLE.instance()
		add_child(firesaw)
		add_child(fireparticle)
		fireparticle.emitting = true
		fireparticle.one_shot = false
		if !Global.godmode:
			Global.mana -= 3
			emit_signal("mana_changed", Global.mana)
		is_attacking = false
		$AttackCollision/CollisionShape2D.disabled = true
		yield(get_tree().create_timer(5),"timeout")
		is_using_firesaw = false
		remove_child(fireparticle)
	
	
func ground_pound():
	if !is_on_floor() and Input.is_action_just_pressed("ui_down"):
		is_ground_pounding = true
		velocity.y = 3000
		$SwordSpreadArea/CollisionPolygon2D.disabled = false
		yield(get_tree().create_timer(0.2), "timeout")
		gp_effect()
		cam_shake = true
		is_ground_pounding = false
		yield(get_tree().create_timer(0.35), "timeout")
		$SwordSpreadArea/CollisionPolygon2D.disabled = true
		cam_shake = false
func gp_effect():
		var gp_particle1 = GROUND_POUND_PARTICLE.instance()
		var gp_particle2 = GROUND_POUND_PARTICLE.instance()
		get_parent().add_child(gp_particle1)
		gp_particle1.position = $GroundPoundPositionRight.global_position
		gp_particle1.rotation_degrees = -40
		gp_particle1.emitting = true
		gp_particle1.one_shot = true
		
		get_parent().add_child(gp_particle2)
		gp_particle2.position = $GroundPoundPositionLeft.global_position
		gp_particle2.rotation_degrees = 220
		gp_particle2.emitting = true
		gp_particle2.one_shot = true

			
func attack():
	if Input.is_action_just_pressed("ui_attack") and !is_attacking and !is_gliding and !is_frozen and $MeleeTimer.is_stopped():
		$Sprite.play("Attack")
		if $Sprite.flip_h:
			$SwordSprite.visible = true
			$AnimationPlayer.play("SwordSwingLeft")
		else:
			$SwordSprite.visible = true
			$AnimationPlayer.play("SwordSwingRight")
		is_attacking = true
		$AttackCollision/CollisionShape2D.disabled = false
		$MeleeTimer.start()
		$AttackTimer.start()
		
		# Upward attack controls
		if Input.is_action_pressed("ui_up") and $MeleeTimer.is_stopped():
			$AttackCollision.position += Vector2(-60,-60) if !$Sprite.flip_h else Vector2(60,-55)
			$Sprite.play("AttackUp")
			
			$SwordSprite.visible = true
			$AnimationPlayer.play("SwordSwingUpper")
#			$Sprite.position += Vector2(0, -20)
			is_attacking = true
			$AttackCollision/CollisionShape2D.disabled = false
			$AttackTimer.start()
		# Downwards attack controls + tiny knock-up
		if Input.is_action_pressed("ui_down")and $MeleeTimer.is_stopped():
			$AttackCollision.position += Vector2(-60,60) if !$Sprite.flip_h else Vector2(60,55)
			$Sprite.play("AttackDown")
			
			$SwordSprite.visible = true
			$AnimationPlayer.play("SwordSwingLower")
#			$Sprite.position += Vector2(0, 20)
			is_attacking = true
			$AttackCollision/CollisionShape2D.disabled = false
			$AttackTimer.start()
func charge_meter():
	$ChargingParticle.visible = true if is_charging else false
	if $ChargeBar.value == $ChargeBar.max_value:
		$ChargeBar.texture_progress = FULL_CHARGE_METER
	else:
		$ChargeBar.texture_progress = CHARGING_CHARGE_METER
	if is_on_floor():
		if Input.is_action_pressed("charge"):
			# Max value is 100
			$ChargeBar.visible = true
			$ChargeBar.value += 2
			is_charging = true
		if Input.is_action_just_released("charge"):
			# Min value is 0 (Empty)
			$ChargeBar.visible = false
			$ChargeBar.value = $ChargeBar.min_value
			is_charging = false
	# Charge abilities
	if $ChargeBar.value == $ChargeBar.max_value and is_charging:
		if Input.is_action_just_pressed("ui_attack") and Global.mana >= 1:
			$ChargeBar.visible = false
			$ChargeBar.value = $ChargeBar.min_value
			is_charging = false
			Input.action_release("charge")
			Global.mana -= 1
			emit_signal("mana_changed", 1)
			var ss_projectile = SUPER_SLASH_PROJECTILE.instance()
			get_parent().add_child(ss_projectile)
			if $Sprite.flip_h:
				ss_projectile.flip_projectile(-1)
			ss_projectile.position = $Position2D.global_position
			var dash_particle = DASH_PARTICLE.instance()
			get_parent().add_child(dash_particle)
			dash_particle.position = $Position2D.global_position
			dash_particle.emitting = true
			dash_particle.one_shot = true
		if Input.is_action_just_pressed("jump") and Global.mana >= 1 and glider_equipped and is_on_floor() and !is_attacking and !is_frozen:
			if !Global.godmode:
				Global.mana -= 1
				emit_signal("mana_changed", Global.mana)
			Input.action_release("charge")
			is_charging = false
			$ChargeBar.visible = false
			$ChargeBar.value = $ChargeBar.min_value
			velocity.y = JUMP_POWER * 1.5
			$Sprite.play("Idle")
			is_attacking = false
			
		

		
# Damage and interaction
func _on_Area2D_area_entered(area : Area2D):
	if area.is_in_group("HealthPot"):
		Global.healthpot_amount += 1
		emit_signal("healthpot_obtained", Global.healthpot_amount)
	if area.is_in_group("LifeWine"):
		Global.lifewine_amount += 1
		emit_signal("lifewine_obtained", Global.lifewine_amount)
	if !Global.godmode:
		if inv_timer.is_stopped():
			if area.is_in_group("Enemy") or area.is_in_group("DeflectedProjectile"):
				Global.hearts -= 0.5
				is_gliding = false
				Input.action_release("charge")
				afterDamaged()
				knockback()
			if area.is_in_group("Enemy2"):
				Global.hearts -= 1
				is_gliding = false
				Input.action_release("charge")
				afterDamaged()
				knockback()
		if area.is_in_group("Spike"):
			Global.hearts -= 0.5
			Input.action_release("charge")
			afterDamaged()
	if area.is_in_group("SlowingPoison"):
		slow_player(2.0)
	if area.is_in_group("Transporter"):
		emit_signal("level_changed")


func attack_knock():
	var KNOCK_POWER : int = 125
	velocity.x = -KNOCK_POWER if !$Sprite.flip_h else KNOCK_POWER

func afterDamaged():
	inv_timer.start() 
	is_invulnerable = true
	emit_signal("life_changed", Global.hearts)
	$Sprite.play("Hurt")
	$KnockbackTimer.start()
	if Global.hearts <= 0:
		if Global.crystals_amount > 0:
			Global.crystals_amount -= 1
			emit_signal("crystals_obtained", Global.crystals_amount)
			Global.hearts += 1
			emit_signal("life_changed", Global.hearts)
			is_invulnerable = true
			yield(get_tree().create_timer(1), "timeout")
			is_invulnerable = false
		else:	
			dead()


# Obtaining mana by attacking enemies
func _on_AttackCollision_area_entered(area):
	if area.is_in_group("Enemy")and !$AttackCollision/CollisionShape2D.disabled:
		attack_knock()
		if Global.mana < Global.max_mana:
			Global.mana += 1
			emit_signal("mana_changed", Global.mana)

func knockback():
	if !Global.godmode:
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
		is_healing = false
		$HealingTimer.stop()
func dash():
	if Global.dash_unlocked and !is_frozen:
		if is_on_floor() and $DashUseTimer.is_stopped():
			can_dash = true
		if !$Sprite.flip_h:
			dashdirection = Vector2(1,0)
		if $Sprite.flip_h:
			dashdirection = Vector2(-1, 0)		
		if Input.is_action_just_pressed("ui_dash") and can_dash and $DashUseTimer.is_stopped() and Global.mana > 0:
			# Particles
			var dash_particle = DASH_PARTICLE.instance()
			get_parent().add_child(dash_particle)
			if !$Sprite.flip_h:
				dash_particle.rotation_degrees = 180
			dash_particle.position = $DashParticlePosition.global_position
			dash_particle.emitting = true
			dash_particle.one_shot = true
			if !Global.godmode:
				Global.mana -= 1
				emit_signal("mana_changed", Global.mana)
			can_dash = false
			Input.action_release("left")
			Input.action_release("right")
			Input.action_release("jump")
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

func glide():
	if Global.glide_unlocked and Input.is_action_just_pressed("toggle_glider"):
		if !glider_equipped:
			glider_equipped = true
		elif glider_equipped:
			glider_equipped = false
	# Press SPACE while in mid-air to temporarily glide
	if Global.glide_unlocked and Input.is_action_just_pressed("jump") and !is_on_floor() and Global.mana >= 1 and glider_equipped:
			if !Global.godmode:
				$GlideTimer.start(0)
			is_gliding = true
			if is_on_floor() or is_on_wall() or is_on_ceiling():
				$GlideTimer.stop()
				is_gliding = false
				velocity.y += GRAVITY * 3
			if is_gliding:
				velocity.y = 0
				velocity.y += GRAVITY * 1.5
	# Stop gliding
	if Input.is_action_just_released("jump"):
		$GlideTimer.stop()
		is_gliding = false
		velocity.y += GRAVITY * 3


func useItems():
	if !is_frozen:
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


func dead():
	get_parent().get_node("DebugMenu").get_node("Control").visible = false
	is_dead = true
	velocity = Vector2(0,0)
	$CollisionShape2D.disabled = true
	$Sprite.visible = false
	get_parent().get_node("GameOverUI/GameOver").visible = true

func on_campfire_toggled():
	is_healing = true
	yield(get_tree().create_timer(2), "timeout")
	Global.hearts += Global.max_hearts - Global.hearts
	emit_signal("life_changed", Global.hearts)
	is_healing = false

func on_manashrine_toggled():
	is_healing = true
	yield(get_tree().create_timer(2), "timeout")
	Global.mana += Global.max_mana - Global.mana
	emit_signal("mana_changed", Global.mana)
	is_healing = false
	
func on_lootbag_obtained(tier : int):
	match tier:
		1:
			# Drops a small amout of opals and common dust
			var lootrng : RandomNumberGenerator = RandomNumberGenerator.new()
			var num  = lootrng.randi_range(1,3)
			lootrng.randomize()
			Global.common_monster_dust_amount += num
			emit_signal("common_monster_dust_obtained", Global.common_monster_dust_amount)
			
			var opalrng : RandomNumberGenerator = RandomNumberGenerator.new()
			opalrng.randomize()
			var opalnum = opalrng.randi_range(5,20)
			Global.opals_amount += opalnum
			emit_signal("opals_obtained", Global.opals_amount)
		2:
			# Drops a small amout of opals, common dust and goblin scales
			var lootrng : RandomNumberGenerator = RandomNumberGenerator.new()
			var num  = lootrng.randi_range(1,5)
			lootrng.randomize()
			Global.common_monster_dust_amount += num
			emit_signal("common_monster_dust_obtained", Global.common_monster_dust_amount)
			
			var opalrng : RandomNumberGenerator = RandomNumberGenerator.new()
			opalrng.randomize()
			var opalnum = opalrng.randi_range(5,20)
			Global.opals_amount += opalnum
			emit_signal("opals_obtained", Global.opals_amount)
			
			var scalesrng : RandomNumberGenerator = RandomNumberGenerator.new()
			scalesrng.randomize()
			var scalesnum = scalesrng.randi_range(1,3)
			Global.goblin_scales_amount += scalesnum
			emit_signal("goblin_scales_obtained", Global.goblin_scales_amount)
			

func on_Item_bought(item_name : String, item_price : int):
	Global.opals_amount -= item_price
	emit_signal("opals_obtained", Global.opals_amount)
	match item_name:
		"HealthPot":
			Global.healthpot_amount += 1
			emit_signal("healthpot_obtained", Global.healthpot_amount)
		"ManaPot":
			Global.manapot_amount += 1
			emit_signal("manapot_obtained", Global.manapot_amount)
		"LifeWine":
			Global.lifewine_amount += 1
			emit_signal("lifewine_obtained", Global.lifewine_amount)
		"ItemPouch_1":
			pass
func on_Item_crafted(item_name : String, common_dust : int, goblin_scales : int):
	print("signal sent")
	Global.common_monster_dust_amount -= common_dust
	Global.goblin_scales_amount -= goblin_scales
	emit_signal("common_monster_dust_obtained", Global.common_monster_dust_amount)
	emit_signal("goblin_scales_obtained", Global.goblin_scales_amount)
	match item_name:
		"HealthPot":
			Global.healthpot_amount += 1
			emit_signal("healthpot_obtained", Global.healthpot_amount)
		"ManaPot":
			Global.manapot_amount += 1
			emit_signal("manapot_obtained", Global.manapot_amount)
		"LifeWine":
			Global.lifewine_amount += 1
			emit_signal("lifewine_obtained", Global.lifewine_amount)
		"ItemPouch_1":
			pass


func debug_commands(cmd : String):
	match cmd:
		"opened":
			is_shopping = true
		"closed":
			is_shopping = false
		"freeze":
			is_frozen = true if !is_frozen else false
		"fillall":
			Global.healthpot_amount += Global.max_item_storage - Global.healthpot_amount
			emit_signal("healthpot_obtained", Global.healthpot_amount)
			Global.manapot_amount += Global.max_item_storage - Global.manapot_amount
			emit_signal("manapot_obtained", Global.manapot_amount)
			Global.lifewine_amount += Global.max_item_storage - Global.lifewine_amount
			emit_signal("lifewine_obtained", Global.lifewine_amount)
			Global.crystals_amount += Global.max_item_storage - Global.crystals_amount
			emit_signal("crystals_obtained", Global.crystals_amount)
		"fillingr":
			Global.common_monster_dust_amount += 99
			emit_signal("common_monster_dust_obtained", Global.common_monster_dust_amount)
			Global.goblin_scales_amount += 99
			emit_signal("goblin_scales_obtained", Global.goblin_scales_amount)
		"opalall":
			Global.opals_amount += 999 - Global.opals_amount
			emit_signal("opals_obtained", Global.opals_amount)
		"healall":
			Global.hearts += Global.max_hearts - Global.hearts
			emit_signal("life_changed", Global.hearts)
			Global.mana += Global.max_mana - Global.mana
			emit_signal("mana_changed", Global.mana)
		"killall":
			for enemy in get_tree().get_nodes_in_group("Enemy"):
				enemy.queue_free()
# Utility functions
func door_opening():
	is_shopping = true
	
func toggle_shopping(value : bool):
	is_shopping = value

func freeze_player(time : float):
	is_frozen = true
	yield(get_tree().create_timer(time), "timeout")
	is_frozen = false

func slow_player(time : float):
	slowed = true
	set_modulate(Color(10, 0, 10, 1))
	SPEED = 380 / 3
	yield(get_tree().create_timer(time), "timeout")
	slowed = false
	set_modulate(Color(1,1,1,1))
	SPEED = 380
	
func get_opals(opals : int):
	Global.opals_amount += opals
	emit_signal("opals_obtained", Global.opals_amount)

# Timers
func _on_InvulnerabilityTimer_timeout():
	if !is_dead:
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
		Global.mana += Global.max_mana - Global.mana
		emit_signal("mana_changed", Global.mana)
		Global.lifewine_amount -= 1
		emit_signal("lifewine_obtained", Global.lifewine_amount)

func _on_ManaHealTimer_timeout():
	is_healing = false
	if Global.manapot_amount > 0 and Global.mana < Global.max_mana:
		Global.mana += Global.max_mana - Global.mana
		emit_signal("mana_changed", Global.mana)
		Global.manapot_amount -= 1
		emit_signal("manapot_obtained", Global.manapot_amount)




func _on_AnimationPlayer_animation_finished(anim_name):
	$SwordSprite.visible = false



func _on_GlideTimer_timeout():
	if is_gliding and glider_equipped:
		Global.mana -= 1
		emit_signal("mana_changed", Global.mana)

	if Global.mana >= 1 and glider_equipped:
		$GlideTimer.start()
	else:
		is_gliding = false
		Input.action_release("jump")
		


func _on_MeleeTimer_timeout():
	pass # Replace with function body.
