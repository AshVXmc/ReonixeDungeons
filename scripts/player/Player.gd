class_name Player extends KinematicBody2D

signal life_changed(player_hearts)
signal mana_changed(player_mana)
signal healthpot_obtained(player_healthpot)
signal lifewine_obtained(player_lifewine)
signal manapot_obtained(player_manapot)
signal opals_obtained(player_opals, amount_added)
signal crystals_obtained(player_crystals)

signal ingredient_obtained(ingredient_name, amount)
signal skill_used(skill_name, character)
signal skill_ui_update()
signal perfect_dash()
signal action(action_type)
signal trigger_quickswap(trigger_name)
signal ready_to_be_switched_in(character)
var target
var can_use_slash_flurry : bool = false
var attack_area_overlaps_enemy : bool 
var resist_interruption : bool = false
const TEMPUS_TARGUS : PackedScene = preload("res://scenes/misc/TempusTardus.tscn")
# Attack buff 
var atkbuffmulti = 0
var atkbuffdur = 0
var basicatkbuffmulti = 0
var basicatkbuffdur = 0
var is_doing_charged_attack : bool = false
# Attack buff for all abilities (Skills)
var atkbuffskill = 0
var buffed_from_attack_crystals = false
var prev_basic_attack_power : Array 
var prev_attack_power : Array 
var prev_charged_attack_power : Array
var number_of_atk_buffs : int = 0
var number_of_charged_atk_buffs : int = 0
var number_of_basic_atk_buffs : int = 0
onready var inv_timer : Timer = $InvulnerabilityTimer
onready var fb_timer : Timer = $FireballTimer
var knockdir : Vector2 = Vector2.ZERO
var velocity : Vector2 = Vector2(0,0)
var healthpot_amount : int = Global.healthpot_amount
var collision : KinematicCollision2D
const TYPE : String = "Player"
const AIRBORNE_STATUS : PackedScene = preload("res://scenes/status_effects/AirborneStatus.tscn")
var dashdirection : Vector2 = Vector2(1,0)
var repulsion : Vector2 = Vector2()
var knockback_power : int = 100
var can_be_knocked : bool = true
var SPEED : int = 380
const GRAVITY : int = 40
var JUMP_POWER : int = -1100
var waiting_for_quickswap : bool = false
var is_thrust_attacking : bool = false
var facing 
enum {
	left, right
}
const SHEATHED = preload("res://assets/player/katana_sheath.png")
const EMPTY_SHEATH = preload("res://assets/player/katana_sheath_empty.png")
const SLASH_FLURRY_AREA = preload("res://scenes/skills/SlashFlurryMovableArea.tscn")
const SWORD_SLASH_EFFECT : PackedScene = preload("res://scenes/particles/SwordSlashEffect.tscn")
const HURT_PARTICLE : PackedScene = preload("res://scenes/particles/HurtIndicatorParticle.tscn")
const JUMP_PARTICLE : PackedScene = preload("res://scenes/particles/JumpParticle.tscn")
const STRONG_JUMP_PARTICLE : PackedScene = preload("res://scenes/particles/StrongJumpParticle.tscn")
const WATER_JUMP_PARTICLE : PackedScene = preload("res://scenes/particles/WaterBubbleParticle.tscn")
const DASH_PARTICLE : PackedScene = preload("res://scenes/particles/DashParticle.tscn")
const SWORD_PARTICLE : PackedScene = preload("res://scenes/particles/SwordSwingParticle.tscn")

const GROUND_POUND_PARTICLE : PackedScene = preload("res://scenes/particles/GroundPoundParticle.tscn")
const SUPER_SLASH_PROJECTILE : PackedScene = preload("res://scenes/misc/SuperSlashProjectile.tscn")
const SWORD_HIT_PARTICLE : PackedScene = preload("res://scenes/particles/SwordHitParticle.tscn")
const FROZEN : PackedScene = preload("res://scenes/status_effects/FrozenStatus.tscn")

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
var is_using_primary_skill : bool = false
var is_using_secondary_skill : bool = false
var glider_equipped : bool = false
var is_ground_pounding : bool = false
var cam_shake : bool = false
var is_charging : bool = false
var slowed : bool = false
var underwater : bool = false
var airborne_mode : bool = false
var mana_absorption_counter_max : int = 3
var mana_absorption_counter : int = mana_absorption_counter_max
var restore_mana_for_all_parties : int = 2
var attack_buff : float
var basic_attack_buff : float
var charged_attack_buff : float 
var attack_string_count : int = 4
var perfect_dash : bool = false
var perfect_charged_attack : bool = false

var phys_res : float = Global.player_skill_multipliers["BasePhysRes"]
var magic_res : float = Global.player_skill_multipliers["BaseMagicRes"]
var fire_res : float = Global.player_skill_multipliers["BaseFireRes"]
var ice_res : float = Global.player_skill_multipliers["BaseIceRes"]
var earth_res : float = Global.player_skill_multipliers["BaseEarthRes"]

onready var basic_attack_power : float = Global.attack_power * (Global.player_skill_multipliers["BasicAttack"] / 100)
onready var charged_attack_power : float = Global.attack_power * (Global.player_skill_multipliers["ChargedAttack"] / 100)
onready var upwards_and_downwards_charged_attack_power :float = Global.attack_power * (Global.player_skill_multipliers["UpwardsorDownwardsChargedAttack"] / 100)
onready var airborne_charged_attack_power :float = Global.attack_power * (Global.player_skill_multipliers["AirborneChargedAttack"] / 100)

# when a flash appears after the 3rd string of basic attack, tap to thrust through enemies
# this can be broken if enemy hits you first

func move_sheath(node_name : String, layer : int):
	move_child(get_node(node_name), layer)

func _ready():
	

	if Global.current_character == "Player":
		$Sprite.visible = true
	$SlashEffectSprite.visible = false
	$AttackCollision.add_to_group(str(basic_attack_power))
	$ChargedAttackCollision.add_to_group(str(charged_attack_power))
	$UpwardsChargedAttackCollision.add_to_group(str(upwards_and_downwards_charged_attack_power))

	$OxygenBar.value = 100
	$ChargeBar.value = 0
	$SwordSprite.visible = false
	$ChargeBar.visible = false
	connect("ready_to_be_switched_in", get_parent().get_node("SkillsUI/Control"), "flicker_icon")
	connect("action", Global, "parse_action")
	connect("perfect_dash", get_parent().get_node("PauseUI/PerfectDash"), "trigger_perfect_dash_animation")
	connect("ingredient_obtained", get_parent().get_node("InventoryUI/Control"), "on_ingredient_obtained")
	emit_signal("ingredient_obtained", "common_dust", Global.common_monster_dust_amount)
	emit_signal("ingredient_obtained", "goblin_scales", Global.goblin_scales_amount)
	connect("skill_ui_update", get_parent().get_node("SkillsUI/Control"), "on_skill_used")
	connect("skill_used", get_node("SkillManager"), "on_skill_used")
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
	connect("life_changed", Global, "sync_hearts")
#	emit_signal("life_changed", Global.hearts)
# warning-ignore:return_value_discarded
	connect("mana_changed", Global, "sync_mana")
	if Global.equipped_characters == [0]:
		emit_signal("mana_changed", Global.mana)
	elif Global.equipped_characters == [1]:
		emit_signal("mana_changed", Global.character2_mana)
	elif Global.equipped_characters == [2]:
		emit_signal("mana_changed", Global.character3_mana)
	
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
	
func quickswap_event(trigger_name : String):
	match trigger_name:
		"Glaciela":
			waiting_for_quickswap = true
			

# Trigger when player is switched in
func switched_in(character):
	if character == "Player":
		if waiting_for_quickswap:
			quickswap_attack()
			waiting_for_quickswap = false

# WOO YEAH BABY
func quickswap_attack():
	print("QUICKSWAP TRIGGERED")
	

func get_closest_enemy() -> Node2D:
	var enemies = get_tree().get_nodes_in_group("Enemy")
	if enemies.empty(): 
		return null
	var distances = []
	for enemy in enemies:
		var distance = global_position.distance_squared_to(enemy.global_position)
		distances.append(distance)
	var min_distance = distances.min()
	var min_index = distances.find(min_distance)
	var closest_enemy = enemies[min_index]
	return closest_enemy
	
func _physics_process(_delta):
	if !$Sprite.flip_h:
		$KatanaSheathPlayer.play("RightDefault")
	else:
		$KatanaSheathPlayer.play("LeftDefault")
		
	if Input.is_action_just_pressed("slot_1"):
		if facing == left:
			facing = right
		elif facing == right:
			facing = left
	# Makes sure the player is alive to use any movement controls
	if !is_invulnerable and !is_healing and !is_shopping and !is_frozen :
		$KatanaSheathSprite.visible = true if Global.current_character == "Player" else false
		target = get_closest_enemy()
		# Function calls
		if Input.is_action_just_pressed("ui_dash"):
			dash()
		if !is_charging:
#			glide() # Glide duration in seconds
			useItems()
			use_skill()
			

#			ground_pound()
			if airborne_mode:
				SPEED = 380 * 0.75
			else:
				SPEED = 380
			
			
			# Movement controls
			if velocity.x == 0 and !is_attacking and !is_gliding and !is_frozen:
				$Sprite.play("Idle")
			if Input.is_action_pressed("left") and !Input.is_action_pressed("right") and !is_attacking and !is_dashing and !is_knocked_back:
				facing = left
			elif Input.is_action_pressed("right") and !Input.is_action_pressed("left") and !is_attacking and !is_knocked_back and !is_dashing:
				facing = right
			else:
				facing = null 
			if !is_doing_charged_attack:
				if facing == left:
					velocity.x = -SPEED
					Input.action_release("right")
					attack_string_count = 4
					mana_absorption_counter = mana_absorption_counter_max
#					$AirborneMaxDuration.start()
#					airborne_mode = false
					$Sprite.play("Glide") if is_gliding else $Sprite.play("Walk")
					$Sprite.flip_h = true
					if velocity.x == 0 and !is_attacking and !is_gliding:
						$Sprite.play("Idle")
					if sign($Position2D.position.x) == 1:
						$Position2D.position.x *= -1
					if sign($DashParticlePosition.position.x) == -1:
						$DashParticlePosition.position.x *= -1
					$AttackCollision.set_scale(Vector2(-1,1))
					$ChargedAttackCollision.set_scale(Vector2(-1,1))
					$ChargedAttackDetector.set_scale(Vector2(-1,1))
					$UpwardsChargedAttackCollision.set_scale(Vector2(-1,1))
					$EnemyEvasionArea.set_scale(Vector2(-1,1))
				elif facing == right:
					Input.action_release("left")
					attack_string_count = 4
					mana_absorption_counter = mana_absorption_counter_max
					velocity.x = SPEED
#					$AirborneMaxDuration.start()
#					airborne_mode = false
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
						
					$AttackCollision.set_scale(Vector2(1,1))
					$ChargedAttackCollision.set_scale(Vector2(1,1))
					$ChargedAttackDetector.set_scale(Vector2(1,1))
					$UpwardsChargedAttackCollision.set_scale(Vector2(1,1))
					$EnemyEvasionArea.set_scale(Vector2(1,1))
			
				# Jump controls (ground)
				if Input.is_action_just_pressed("jump") and is_on_floor() and !is_attacking and !is_frozen and !underwater:
					# Particles
					var jump_particle : JumpParticle = JUMP_PARTICLE.instance()
					jump_particle.emitting = true
					get_parent().add_child(jump_particle)
					jump_particle.position = $ParticlePosition.global_position
					velocity.y = JUMP_POWER
					$Sprite.play("Idle")
	#				is_attacking = false
					print("Jumping")
				# Jump controls (water)
				if Input.is_action_just_pressed("jump") and underwater and !is_attacking and !is_frozen:
					var water_jump_particle = WATER_JUMP_PARTICLE.instance()
					water_jump_particle.emitting = true
					get_parent().add_child(water_jump_particle)
					water_jump_particle.position = $ParticlePosition.global_position
					velocity.y = JUMP_POWER / 1.8
					$Sprite.play("Idle")
				
#				is_attacking = false
				
			# Movement calculations
#			if !is_dashing and !is_gliding:
#				velocity.y += GRAVITY
			velocity = move_and_slide(velocity,Vector2.UP)
			velocity.x = lerp(velocity.x,0,0.2)
			if is_invulnerable:
				$Area2D/CollisionShape2D.disabled = true
			if Input.is_action_just_pressed("ui_use"):
				$ToggleArea/CollisionShape2D.disabled = false
				yield(get_tree().create_timer(0.5), "timeout")
				$ToggleArea/CollisionShape2D.disabled = true
	if !is_dashing and !is_gliding and !airborne_mode:
		if underwater:
			velocity.y += GRAVITY / 2
		else:
			velocity.y += GRAVITY
	if airborne_mode:
		velocity.y = 0

	if is_healing:
		$Sprite.play("Healing")
	if is_frozen:
		$Sprite.play("Frozen")
	$FreezeMask.visible = true if is_frozen else false
#	if glider_equipped and !is_gliding:
#		$GliderWings.visible = true
#	if !glider_equipped or is_gliding:
#		$GliderWings.visible = false
#	if is_gliding:
#		$Sprite.play("Glide")
#		$GliderWings.visible = false
	if cam_shake:
		$Camera2D.set_offset(Vector2( \
			rand_range(-1, 1) * 2.0, \
			rand_range(-1, 1) * 2.5 \
		))
	if is_shopping:
		is_invulnerable = true
	else:
		is_invulnerable = false
	$AtkBuffParticle.visible = true if buffed_from_attack_crystals else false

	charge_meter()
	
	$Sprite.visible = true if Global.current_character == "Player" else false
	if Global.current_character != "Player":
		mana_absorption_counter = mana_absorption_counter_max
		restore_mana_for_all_parties = 2



func set_basic_attack_power(amount : float, duration : float, show_particles : bool = true):
	# DONT ASK THIS IS SO COMPLICATED ON GODDDD
		buffed_from_attack_crystals = true
		number_of_basic_atk_buffs += 1
		prev_basic_attack_power.insert((number_of_basic_atk_buffs - 1), basic_attack_buff) 
		print(prev_basic_attack_power)
		basic_attack_buff = prev_basic_attack_power[number_of_basic_atk_buffs - 1] + amount
		
		print("Buffed: " + str(basic_attack_buff))
		yield(get_tree().create_timer(duration), "timeout")
		basic_attack_buff = prev_basic_attack_power[number_of_basic_atk_buffs - 1]
		print("DeBuffed: " + str(prev_basic_attack_power[number_of_basic_atk_buffs - 1]))
		number_of_basic_atk_buffs -= 1
		prev_basic_attack_power.remove(number_of_basic_atk_buffs)
		
		buffed_from_attack_crystals = false

func set_attack_power(amount : float, duration : float, show_particles : bool = true):
		buffed_from_attack_crystals = true
		number_of_atk_buffs += 1
		
		var other_groups : Array
		prev_attack_power.insert((number_of_atk_buffs - 1), attack_buff) 
		print(prev_attack_power)
		attack_buff = prev_attack_power[number_of_atk_buffs - 1] + amount
		
		print("Buffed: " + str(attack_buff))
		yield(get_tree().create_timer(duration), "timeout")
		attack_buff = prev_attack_power[number_of_atk_buffs - 1]
		print("DeBuffed: " + str(prev_attack_power[number_of_atk_buffs - 1]))
		number_of_atk_buffs -= 1
		prev_attack_power.remove(number_of_atk_buffs)
		buffed_from_attack_crystals = false
		
func set_charged_attack_power(amount : float, duration : float, show_particles : bool = true):
		buffed_from_attack_crystals = true
		number_of_charged_atk_buffs += 1
		
		var other_groups : Array
		prev_charged_attack_power.insert((number_of_charged_atk_buffs - 1), charged_attack_buff) 
		print(prev_charged_attack_power)
		charged_attack_buff = prev_charged_attack_power[number_of_charged_atk_buffs - 1] + amount
		
		print("Buffed: " + str(charged_attack_buff))
		yield(get_tree().create_timer(duration), "timeout")
		charged_attack_buff = prev_charged_attack_power[number_of_charged_atk_buffs - 1]
		print("DeBuffed: " + str(prev_charged_attack_power[number_of_charged_atk_buffs - 1]))
		number_of_charged_atk_buffs -= 1
		prev_charged_attack_power.remove(number_of_charged_atk_buffs)
		buffed_from_attack_crystals = false
func use_skill():
	if Global.current_character == "Player":
		if Input.is_action_just_pressed("primary_skill") and !Input.is_action_just_pressed("secondary_skill") and !is_frozen and !is_using_primary_skill and get_parent().get_node("SkillsUI/Control/PrimarySkill/Player/FireSaw/FiresawTimer").is_stopped():
			use_primary_skill()
			
		if Input.is_action_just_pressed("secondary_skill") and !Input.is_action_just_pressed("primary_skill"):
			use_secondary_skill()
			

func use_primary_skill():
	if Global.current_character == Global.equipped_characters[0] and Global.mana >= Global.player_skill_multipliers["FireSawCost"]:
		emit_signal("skill_used", "FireSaw", attack_buff)
		emit_signal("skill_ui_update", "FireSaw")
		emit_signal("mana_changed", Global.mana, "Player")
		print("USED PRIMARY SKILL")
	elif Global.current_character == Global.equipped_characters[1] and Global.character2_mana >= Global.player_skill_multipliers["FireSawCost"]:
		emit_signal("skill_used", "FireSaw", attack_buff)
		emit_signal("skill_ui_update", "FireSaw")
		emit_signal("mana_changed", Global.character2_mana, "Player")
	elif Global.current_character == Global.equipped_characters[2] and Global.character3_mana >= Global.player_skill_multipliers["FireSawCost"]:
		emit_signal("skill_used", "FireSaw", attack_buff)
		emit_signal("skill_ui_update", "FireSaw")
		emit_signal("mana_changed", Global.character3_mana, "Player")
	
func use_secondary_skill():
	if Global.player_skills["SecondarySkill"] == "FireFairy" and Global.fire_fairy_unlocked and !is_frozen and Global.mana >= 4 and !is_using_secondary_skill and get_parent().get_node("SkillsUI/Control/SecondarySkill/Player/FireFairy/FirefairyTimer").is_stopped():
			emit_signal("skill_used", "FireFairy")
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
	if Global.current_character == "Player" and !is_attacking and !is_gliding and !is_frozen and $MeleeTimer.is_stopped() and $ChargeBar.value != $ChargeBar.max_value:
		$Sprite.play("Attack")
		
#		if !$Sprite.flip_h and enemy_on_left_detector():
#			Input.action_press("left")
#			Input.action_release("left")
#		elif $Sprite.flip_h and enemy_on_right_detector():
#			Input.action_press("right")
#			Input.action_release("right")
#
		
		if $Sprite.flip_h:
			$SwordSprite.visible = true
			play_attack_animation("Left")
		else:
			$SwordSprite.visible = true
			play_attack_animation("Right")
		is_attacking = true
		$AttackCollision/CollisionShape2D.disabled = false
		$MeleeTimer.start()
		$AttackTimer.start()
		
		# Upward attack controls
#		if Input.is_action_pressed("ui_up"):
#			$AttackCollision.position += Vector2(-60,-60) if !$Sprite.flip_h else Vector2(60,-55)
#			$Sprite.play("AttackUp")
#			print("up attack")
#			$SwordSprite.visible = true
#			$AnimationPlayer.play("SwordSwingUpper")
##			$Sprite.position += Vector2(0, -20)
#			is_attacking = true
#			$AttackCollision/CollisionShape2D.disabled = false
#			$AttackTimer.start()
		# Downwards attack controls + tiny knock-up
		if Input.is_action_pressed("ui_down"):
			$AttackCollision.position += Vector2(-60,60) if !$Sprite.flip_h else Vector2(60,55)
			$Sprite.play("AttackDown")
			
			$SwordSprite.visible = true
			$AnimationPlayer.play("SwordSwingLower")
#			$Sprite.position += Vector2(0, 20)
			is_attacking = true
			$AttackCollision/CollisionShape2D.disabled = false
			$AttackTimer.start()

func _input(event):
	if Global.current_character == "Player":
		if event.is_action_pressed("ui_attack") and $InputPressTimer.is_stopped():

			attack()
			$InputPressTimer.start()
		if event.is_action_pressed("ui_down") and airborne_mode:
			airborne_mode = false


	
func charged_attack():
	$InputPressTimer.stop()

	is_doing_charged_attack = true
	if !$Sprite.flip_h:
		$AnimationPlayer.play("ChargedAttackRight")
	else:
		$AnimationPlayer.play("ChargedAttackLeft")
	yield(get_tree().create_timer(0.35), "timeout")
	$AirborneTimer.start()

	$ChargedAttackCollision/CollisionShape2D.disabled = false
	
	print("normal charged attack")
	
	Input.action_release("charge")
	if !airborne_mode:
		var ss_projectile = SUPER_SLASH_PROJECTILE.instance()
		ss_projectile.position = $Position2D.global_position
		get_parent().add_child(ss_projectile)
		if $Sprite.flip_h:
			ss_projectile.flip_projectile(-1)
	
	var hitparticle = SWORD_HIT_PARTICLE.instance()

	hitparticle.emitting = true
	get_parent().add_child(hitparticle)
	hitparticle.position = $Position2D.global_position

	if airborne_mode and $SlashFlurryCD.is_stopped():
		velocity.y = 0
		var slashparticle = SWORD_SLASH_EFFECT.instance()
		var flurry = SLASH_FLURRY_AREA.instance()
		flurry.add_to_group("Sword")
		var atkvalue = Global.player_skill_multipliers["AirborneChargedAttack"] # + airbornechargedatkbuff
		flurry.add_to_group(str(atkvalue))
		get_parent().add_child(slashparticle)
		get_parent().add_child(flurry)
		if weakref(get_closest_enemy()).get_ref() != null and $SlashFlurryDetector.overlaps_body(get_closest_enemy()):
			flurry.position = get_closest_enemy().global_position
			slashparticle.position = flurry.global_position
		else:
			if !$Sprite.flip_h:
				flurry.position.x = global_position.x + 150
				flurry.position.y = global_position.y
				slashparticle.position = flurry.global_position
			else:
				flurry.position.x = global_position.x - 150
				flurry.position.y = global_position.y
				slashparticle.position = flurry.global_position
		cam_shake = true
		if !$Sprite.flip_h:
			dashdirection = Vector2(1,0)
		if $Sprite.flip_h:
			dashdirection = Vector2(-1, 0)
		velocity = dashdirection.normalized() * -250
		slashparticle.flurry_slash_animation()
		$SlashFlurryCD.start()
		yield(get_tree().create_timer(0.5), "timeout")
		cam_shake = false
	if !airborne_mode:
		cam_shake = true
		yield(get_tree().create_timer(0.25), "timeout")
		cam_shake = false

	var dash_particle = DASH_PARTICLE.instance()
	get_parent().add_child(dash_particle)
	dash_particle.position = $Position2D.global_position
	dash_particle.emitting = true
	dash_particle.one_shot = true
	
	yield(get_tree().create_timer(0.1), "timeout")

	$ChargedAttackCollision/CollisionShape2D.disabled = true
	is_doing_charged_attack = false
	attack_string_count = 4
	is_charging = false
	Input.action_release("ui_attack")
func charge_meter():
	if Global.current_character == "Player":
		if Input.is_action_just_released("ui_attack"):
			$InputPressTimer.stop()
			print("cancel atk input")
		$ChargingParticle.visible = true if is_charging else false
		if !Input.is_action_pressed("ui_down") and !Input.is_action_pressed("ui_up"):
			if Input.is_action_pressed("ui_attack") and $InputPressTimer.is_stopped():
				$InputPressTimer.start()
				
#			elif Input.is_action_just_pressed("ui_attack") and $ChargeBar.value == $ChargeBar.max_value and Global.mana < 2:
#				$ChargeBar.visible = false
#				$ChargeBar.value = $ChargeBar.min_value
#				is_charging = false
#			if Input.is_action_just_pressed("jump") and Global.mana >= 1 and glider_equipped and is_on_floor() and !is_attacking and !is_frozen and !underwater:
#				if !Global.godmode:
#					Global.mana -= 1
#					emit_signal("mana_changed", Global.mana, "Player")
#				attack_string_count = 4
#				mana_absorption_counter = mana_absorption_counter_max
#				Input.action_release("charge")
#				is_charging = false
#				$ChargeBar.visible = false
#				$ChargeBar.value = $ChargeBar.min_value
#				velocity.y = JUMP_POWER * 1.5
#				$Sprite.play("Idle")
#				is_attacking = false
		if Input.is_action_pressed("ui_up") and !airborne_mode:
			if Input.is_action_pressed("ui_attack") and $InputPressTimer.is_stopped() and !is_doing_charged_attack:
				$InputPressTimer.start()
				

func upwards_charged_attack():
	if target and target != null and weakref(target).get_ref() != null: 
		if target.get_node("Area2D").overlaps_area($ChargedAttackDetector) and !target.get_node("Area2D").is_in_group("IsAirborne"):
			attack_string_count = 4
			$UpwardsChargedAttackCollision/CollisionShape2D.disabled = false
			resist_interruption = true
			print("Up charged attack")
			is_charging = false
#			airborne_mode = false
			is_doing_charged_attack = true
			cam_shake = true
			knock_airborne(target.get_node("Area2D"))
			velocity.y = 0
			velocity.y = -1065
			var sjp = STRONG_JUMP_PARTICLE.instance()
			get_parent().add_child(sjp)
			sjp.position = $ParticlePosition.global_position
			sjp.emitting = true
			if !$Sprite.flip_h:
				$AnimationPlayer.play("KnockUpChargedAttackRight")
				yield(get_tree().create_timer(0.2), "timeout")
				$AnimationPlayer.play("KnockUpChargedAttackRight")
			else:
				$AnimationPlayer.play("KnockUpChargedAttackLeft")
				yield(get_tree().create_timer(0.2), "timeout")
				$AnimationPlayer.play("KnockUpChargedAttackLeft")
			is_doing_charged_attack = false
			Input.action_release("ui_attack")
			$AirborneTimer.start()
			$UpwardsChargedAttackCollision/CollisionShape2D.disabled = true
			cam_shake = false
			yield(get_tree().create_timer(0.15), "timeout")
			resist_interruption = false
#			airborne_mode = true
	
				
			

func play_attack_animation(direction : String):
	if direction == "Right":
		match attack_string_count:
			4:
				
				$AnimationPlayer.play("SwordSwingRight")
				attack_string_count -= 1
				$SlashEffectPlayer.play("RightSlash")
				for groups in $AttackCollision.get_groups():
					if float(groups) != 0:
						$AttackCollision.remove_from_group(groups)
						if !airborne_mode:
							$AttackCollision.add_to_group(str(Global.attack_power * (Global.player_skill_multipliers["BasicAttack"] / 100) + basic_attack_buff))
							print("a")
						else:
							$AttackCollision.add_to_group(str(Global.attack_power * (Global.player_skill_multipliers["AirborneBasicAttack"] / 100) + basic_attack_buff))
							print("b")
						break
				
			3:
				$AnimationPlayer.play("SwordSwingRight2")
				attack_string_count -= 1
				$SlashEffectPlayer.play("RightSlash")
				
				for groups in $AttackCollision.get_groups():
					if float(groups) != 0:
						$AttackCollision.remove_from_group(groups)
						if !airborne_mode:
							$AttackCollision.add_to_group(str(Global.attack_power * (Global.player_skill_multipliers["BasicAttack2"] / 100) + basic_attack_buff))
						else:
							$AttackCollision.add_to_group(str(Global.attack_power * (Global.player_skill_multipliers["AirborneBasicAttack2"] / 100) + basic_attack_buff))
						break
			2:
				$AnimationPlayer.play("SwordSwingRight3")
				attack_string_count -= 1
				$SlashEffectPlayer.play("RightSlash")
				
				for groups in $AttackCollision.get_groups():
					if float(groups) != 0:
						$AttackCollision.remove_from_group(groups)
						if !airborne_mode:
							$AttackCollision.add_to_group(str(Global.attack_power * (Global.player_skill_multipliers["BasicAttack3"] / 100) + basic_attack_buff))
						else:
							$AttackCollision.add_to_group(str(Global.attack_power * (Global.player_skill_multipliers["AirborneBasicAttack3"] / 100) + basic_attack_buff))
						break
			1:
				$AnimationPlayer.play("SwordSwingRight4")
				attack_string_count -= 1
				$SlashEffectPlayer.play("RightSlash")
				for groups in $AttackCollision.get_groups():
					if float(groups) != 0:
						$AttackCollision.remove_from_group(groups)
						if !airborne_mode:
							$AttackCollision.add_to_group(str(Global.attack_power * (Global.player_skill_multipliers["BasicAttack4"] / 100) + basic_attack_buff))
						else:
							$AttackCollision.add_to_group(str(Global.attack_power * (Global.player_skill_multipliers["AirborneBasicAttack4"] / 100) + basic_attack_buff))
						break
				yield(get_tree().create_timer($MeleeTimer.wait_time), "timeout")
				attack_string_count = 4
				mana_absorption_counter = mana_absorption_counter_max
	elif direction == "Left":
		match attack_string_count:
			4:
				$AnimationPlayer.play("SwordSwingLeft")
				attack_string_count -= 1

				for groups in $AttackCollision.get_groups():
					if float(groups) != 0:
						$AttackCollision.remove_from_group(groups)
						if !airborne_mode:
							$AttackCollision.add_to_group(str(Global.attack_power * (Global.player_skill_multipliers["BasicAttack"] / 100) + basic_attack_buff))
						else:
							$AttackCollision.add_to_group(str(Global.attack_power * (Global.player_skill_multipliers["AirborneBasicAttack"] / 100) + basic_attack_buff))
						break
				
			3:
				$AnimationPlayer.play("SwordSwingLeft2")
				attack_string_count -= 1

				for groups in $AttackCollision.get_groups():
					if float(groups) != 0:
						$AttackCollision.remove_from_group(groups)
						if !airborne_mode:
							$AttackCollision.add_to_group(str(Global.attack_power * (Global.player_skill_multipliers["BasicAttack2"] / 100) + basic_attack_buff))
						else:
							$AttackCollision.add_to_group(str(Global.attack_power * (Global.player_skill_multipliers["AirborneBasicAttack2"] / 100) + basic_attack_buff))
						break
			2:
				$AnimationPlayer.play("SwordSwingLeft3")
				attack_string_count -= 1

				for groups in $AttackCollision.get_groups():
					if float(groups) != 0:
						$AttackCollision.remove_from_group(groups)
						if !airborne_mode:
							$AttackCollision.add_to_group(str(Global.attack_power * (Global.player_skill_multipliers["BasicAttack3"] / 100) + basic_attack_buff))
						else:
							$AttackCollision.add_to_group(str(Global.attack_power * (Global.player_skill_multipliers["AirborneBasicAttack3"] / 100) + basic_attack_buff))
						break
			1:
				$AnimationPlayer.play("SwordSwingLeft4")
				attack_string_count -= 1

				for groups in $AttackCollision.get_groups():
					if float(groups) != 0:
						$AttackCollision.remove_from_group(groups)
						if !airborne_mode:
							$AttackCollision.add_to_group(str(Global.attack_power * (Global.player_skill_multipliers["BasicAttack4"] / 100) + basic_attack_buff))
						else:
							$AttackCollision.add_to_group(str(Global.attack_power * (Global.player_skill_multipliers["AirborneBasicAttack4"] / 100) + basic_attack_buff))
						break
				yield(get_tree().create_timer($MeleeTimer.wait_time), "timeout")
				attack_string_count = 4
				mana_absorption_counter = mana_absorption_counter_max
# Damage and interaction
func _on_Area2D_area_entered(area : Area2D):
	if Global.current_character == "Player":
		if area.is_in_group("HealthPot"):
			Global.healthpot_amount += 1
			emit_signal("healthpot_obtained", Global.healthpot_amount)
		if area.is_in_group("LifeWine"):
			Global.lifewine_amount += 1
			emit_signal("lifewine_obtained", Global.lifewine_amount)
		if !Global.godmode:
					
			if inv_timer.is_stopped() and !is_invulnerable and !is_dashing and perfect_dash:
				if area.is_in_group("Enemy") and area.is_in_group("Hostile")or area.is_in_group("DeflectedProjectile"):
					match area.get_parent().elemental_type:
						"Physical":
							var dmg = area.get_parent().atk_value
							take_damage(dmg * (1 - phys_res))
					
					is_gliding = false
					Input.action_release("charge")
					Input.action_release("ui_attack")
					afterDamaged()
					if !area.is_in_group("LightEnemy") or !resist_interruption:
						knockback()
					$CampfireTimer.stop()
#				if area.is_in_group("Enemy2"):
#					take_damage(2)
#					add_hurt_particles(1)
#					is_gliding = false
#					Input.action_release("charge")
#					afterDamaged()
#					knockback()
#					$CampfireTimer.stop()
			if area.is_in_group("Spike"):
				Global.hearts -= 0.5
				Input.action_release("charge")
				afterDamaged()
				$CampfireTimer.stop()
		if area.is_in_group("SlowingPoison"):
			slow_player(2.0)
		if area.is_in_group("Transporter"):
			emit_signal("level_changed")
		if area.is_in_group("Water"):
			$OxygenBar.visible = true
			var water_jump_particle = WATER_JUMP_PARTICLE.instance()
			water_jump_particle.emitting = true
			get_parent().add_child(water_jump_particle)
			water_jump_particle.position = $ParticlePosition.global_position
			$OxygenTimer.start()
			underwater = true
			velocity.y = 0
			print("is underwater")
		if area.is_in_group("BasicAttackBuff"):
			basicatkbuffmulti = area.amount
			basicatkbuffdur = area.duration
			set_basic_attack_power(float(basicatkbuffmulti), float(basicatkbuffdur))
			print("STRONK")
		if area.is_in_group("AttackBuff"):
			atkbuffmulti = area.amount
			atkbuffdur = area.duration
			set_attack_power(float(atkbuffmulti), float(atkbuffdur))
func take_damage(damage : float):
	if Global.current_character == "Player":
		if Global.equipped_characters[0] == "Player":
			Global.hearts -= damage
			emit_signal("life_changed", Global.hearts, "Player")
		elif Global.equipped_characters[1] == "Player":
			Global.character2_hearts -= damage
			emit_signal("life_changed", Global.character2_hearts, "Player")
		elif Global.equipped_characters[2] == "Player":
			Global.character3_hearts -= damage
			emit_signal("life_changed", Global.character3_hearts, "Player")


		
func _on_Area2D_area_exited(area):
	if area.is_in_group("Water"):
		
		underwater = false
		yield(get_tree().create_timer(1), "timeout")
		$OxygenTimer.stop()
		if $OxygenBar.value < 100:
			$OxygenRefillTimer.start()
		print("not underwater")

func attack_knock():
	var KNOCK_POWER : int = 75
	velocity.x = -KNOCK_POWER if !$Sprite.flip_h else KNOCK_POWER

func afterDamaged():
	inv_timer.start() 
	$HurtAnimationPlayer.play("Hurt")
	is_invulnerable = true
#	emit_signal("life_changed", Global.hearts)
	$Sprite.play("Hurt")
	if !Global.godmode:
		$KnockbackTimer.start()
		
	if Global.equipped_characters[0] == Global.current_character:
		if Global.hearts <= 0:
			dead(Global.equipped_characters[0])
	elif Global.equipped_characters[1] == Global.current_character:
		if Global.hearts <= 0:
			dead(Global.equipped_characters[1])
	elif Global.equipped_characters[2] == Global.current_character:
		if Global.hearts <= 0:
			dead(Global.equipped_characters[2])

func dead(character_id):
	if character_id == Global.equipped_characters[0]:
		Global.alive[0] = false
	elif character_id == Global.equipped_characters[1]:
		Global.alive[1] = false
	elif character_id == Global.equipped_characters[2]:
		Global.alive[2] = false
func add_hurt_particles(damage : float):
	var hurt_particle = HURT_PARTICLE.instance()
	hurt_particle.damage = damage * 2
	get_parent().add_child(hurt_particle)
	hurt_particle.position = global_position
# Obtaining mana by attacking enemies
func _on_AttackCollision_area_entered(area):
	if weakref(area).get_ref() != null:
		if area.is_in_group("Enemy")  and !$AttackCollision/CollisionShape2D.disabled:
			print(attack_string_count)
			if !is_on_floor() and !$HeightRaycast2D.is_colliding():
				airborne_mode = true
				$AirborneTimer.start()
			attack_area_overlaps_enemy = true
#			attack_knock()
#			freeze_enemy()
			if Global.current_character == "Player":
				if area.is_in_group("Enemy"):
					change_mana_value(0.25)
				var hitparticle = SWORD_HIT_PARTICLE.instance()
				var slashparticle = SWORD_SLASH_EFFECT.instance()
				hitparticle.emitting = true
				get_parent().add_child(hitparticle)
				get_parent().add_child(slashparticle)
				hitparticle.position = area.global_position
				
				slashparticle.position = area.global_position
				
				slashparticle.regular_slash_animation()
				if mana_absorption_counter > 0:
					mana_absorption_counter -= 1
				
#				if mana_absorption_counter == 0 and $ChargeBar.value != $ChargeBar.max_value:
#					mana_absorption_counter = mana_absorption_counter_max
	
	if weakref(area).get_ref() != null:
		if area.is_in_group("Airborne"):

			get_node("AirborneTimer").start()
			airborne_mode = true

func _on_ChargedAttackCollision_area_entered(area):
	if weakref(area).get_ref() != null:
		if area.is_in_group("Enemy"):
			if Global.current_character == "Player" and $ManaRegenDelay.is_stopped():
				$ManaRegenDelay.start()
				print("charged attack restore mana")
				change_mana_value(0.25)
				print("mana: " + str(Global.mana))
#				
				if mana_absorption_counter > 0:
					mana_absorption_counter -= 1
	
func change_mana_value(amount : float):
	if Global.current_character == Global.equipped_characters[0] and Global.mana < Global.max_mana:
		Global.mana += amount
		emit_signal("mana_changed", Global.mana, "Player")
	elif Global.current_character == Global.equipped_characters[1] and Global.character2_mana < Global.character2_max_mana:
		Global.character2_mana += amount
		emit_signal("mana_changed", Global.character2_mana, "Player")
	elif Global.current_character == Global.equipped_characters[2] and Global.character3_mana < Global.character3_max_mana:
		Global.character3_mana += amount
		emit_signal("mana_changed", Global.character3_mana, "Player")
func freeze_enemy():
	var frozen_status = FROZEN.instance()
	var enemy = $AttackCollision.get_overlapping_areas()
	print(enemy)
	for e in enemy:
		if e.is_in_group("Enemy"):
			e.add_child(frozen_status)
	enemy.clear()


func knockback():
	if can_be_knocked and !Global.godmode and !resist_interruption:
		is_knocked_back = true
		$KnockbackCooldownTimer.start()
		can_be_knocked = false
	dashdirection = Vector2(-1, 0) if $Sprite.flip_h else Vector2(1,0)
	Input.action_release("jump")
#	Input.action_release("left")
#	Input.action_release("right")
	Input.action_release("ui_attack")
	Input.action_release("ui_up")

func _on_LeftDetector_area_entered(area):
	if !Global.godmode:
		if is_invulnerable and area.is_in_group("Enemy") or area.is_in_group("Enemy2") and is_knocked_back:
			if !area.is_in_group("LightEnemy"):
				velocity.x = 1000
				$KnockbackCooldownTimer.start()
				velocity.y = JUMP_POWER * 0.25
			is_healing = false
			$HealingTimer.stop()
func _on_RightDectector_area_entered(area):
	if !Global.godmode:
		if is_invulnerable and area.is_in_group("Enemy") or area.is_in_group("Enemy2") and is_knocked_back:
			if !area.is_in_group("LightEnemy") or !resist_interruption:
				velocity.x = -1000
				$KnockbackCooldownTimer.start()
				velocity.y = JUMP_POWER * 0.25
			is_healing = false
			$HealingTimer.stop()
func dash():
	
	if Global.dash_unlocked and !is_frozen and !is_thrust_attacking:
		
		if is_on_floor() and $DashUseTimer.is_stopped():
			can_dash = true
		if !$Sprite.flip_h:
			dashdirection = Vector2(1,0)
		if $Sprite.flip_h:
			dashdirection = Vector2(-1, 0)
		if can_dash and $DashUseTimer.is_stopped():
			attack_string_count = 4
			mana_absorption_counter = mana_absorption_counter_max
			is_dashing = true
			var dash_particle = DASH_PARTICLE.instance()
			get_parent().add_child(dash_particle)
			if !$Sprite.flip_h:
				dash_particle.rotation_degrees = 180
			dash_particle.position = $DashParticlePosition.global_position
			dash_particle.emitting = true
			dash_particle.one_shot = true
			can_dash = false
			Input.action_release("jump")
			$DashUseTimer.start()
			if !$HeightRaycast2D.is_colliding():
				airborne_mode = true
				$AirborneMaxDuration.start()
			if perfect_dash and !airborne_mode and is_on_floor() and !Input.is_action_pressed("left") and !Input.is_action_pressed("right"):
#				is_invulnerable = true
				velocity.y = 0
				$Sprite.play("PerfectDash")
				velocity = dashdirection.normalized() * -2000
				can_use_slash_flurry = true

			else:
				velocity.y = 0
				$Sprite.play("Dash")
				velocity = dashdirection.normalized() * 2000
#				airborne_mode = false 
			yield(get_tree().create_timer(0.2), "timeout")
			perfect_dash = false
#			airborne_mode = false
			$DashCooldown.start()
			
			velocity.y += GRAVITY
			is_dashing = false

func thrust_attack():
	is_thrust_attacking = true
	var thrustdirection : Vector2
	var swordslash = SWORD_SLASH_EFFECT.instance()
	if !$Sprite.flip_h:
		thrustdirection = Vector2(1,0)
	if $Sprite.flip_h:
		thrustdirection = Vector2(-1, 0)
	attack_string_count = 4
	mana_absorption_counter = mana_absorption_counter_max
	var dash_particle = DASH_PARTICLE.instance()
	get_parent().add_child(dash_particle)
	if !$Sprite.flip_h:
		dash_particle.rotation_degrees = 180
	dash_particle.position = $DashParticlePosition.global_position
	dash_particle.emitting = true
	dash_particle.one_shot = true
	get_parent().add_child(swordslash)
	swordslash.position = global_position
	swordslash.horizontal_slash_animation()
	Input.action_release("jump")
	velocity.y = 0
	$Sprite.play("Dash")
	$SlashEffectPlayer.play("HorizontalSlash")
	velocity = thrustdirection.normalized() * 2500
	is_thrust_attacking = false

		
func knock_airborne(target):
	if target and weakref(target).get_ref() != null and !target.is_in_group("IsAirborne") and !target.get_parent().is_in_group("Armored"):
		if $KnockAirborneICD.is_stopped():
			var airborne_status := AIRBORNE_STATUS.instance()
			target.get_parent().add_child(airborne_status)
			$KnockAirborneICD.start()

#func glide():
#	if Global.glide_unlocked and Input.is_action_just_pressed("toggle_glider"):
#		if !glider_equipped:
#			glider_equipped = true
#		elif glider_equipped:
#			glider_equipped = false
#	# Press SPACE while in mid-air to temporarily glide
#	if Global.glide_unlocked and Input.is_action_just_pressed("jump") and !is_on_floor() and Global.mana >= 1 and glider_equipped:
#			if !Global.godmode:
#				$GlideTimer.start(0)
#			is_gliding = true
#			if is_on_floor() or is_on_wall() or is_on_ceiling():
#				$GlideTimer.stop()
#				is_gliding = false
#				velocity.y += GRAVITY * 3
#			if is_gliding:
#				velocity.y = 0
#				velocity.y += GRAVITY * 1.5
	# Stop gliding
	if Input.is_action_just_released("jump") or is_on_floor():
		$GlideTimer.stop()
		is_gliding = false
#		if !airborne_mode:
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


func game_over():
	get_parent().get_node("DebugMenu").get_node("Control").visible = false
	is_dead = true
	velocity = Vector2(0,0)
	$CollisionShape2D.disabled = true
	$Sprite.visible = false
	get_parent().get_node("GameOverUI/GameOver").visible = true



func on_manashrine_toggled():
	is_healing = true
	yield(get_tree().create_timer(2), "timeout")
	Global.mana += Global.max_mana - Global.mana
	emit_signal("mana_changed", Global.mana, Global.equipped_characters[0])
	emit_signal("mana_changed", Global.mana, Global.equipped_characters[1])
	emit_signal("mana_changed", Global.mana, Global.equipped_characters[2])
	is_healing = false
	
func on_lootbag_obtained(tier : int):
	match tier:
		1:
			# Drops a small amout of opals and common dust
			var lootrng : RandomNumberGenerator = RandomNumberGenerator.new()
			var num  = lootrng.randi_range(1,3)
			lootrng.randomize()
			Global.common_monster_dust_amount += num
			
			emit_signal("ingredient_obtained", "common_dust", Global.common_monster_dust_amount)
			
			var opalrng : RandomNumberGenerator = RandomNumberGenerator.new()
			opalrng.randomize()
			var opalnum = opalrng.randi_range(5,20)
			Global.opals_amount += opalnum
			emit_signal("opals_obtained", Global.opals_amount, opalnum)
		2:
			# Drops a small amout of opals, common dust and goblin scales
			var lootrng : RandomNumberGenerator = RandomNumberGenerator.new()
			var num  = lootrng.randi_range(1,5)
			lootrng.randomize()
			Global.common_monster_dust_amount += num
			emit_signal("ingredient_obtained", "common_dust", Global.common_monster_dust_amount)
			var opalrng : RandomNumberGenerator = RandomNumberGenerator.new()
			opalrng.randomize()
			var opalnum = opalrng.randi_range(5,20)
			Global.opals_amount += opalnum
			emit_signal("opals_obtained", Global.opals_amount, opalnum)
			
			var scalesrng : RandomNumberGenerator = RandomNumberGenerator.new()
			scalesrng.randomize()
			var scalesnum = scalesrng.randi_range(1,3)
			Global.goblin_scales_amount += scalesnum
			emit_signal("ingredient_obtained", "goblin_scales", Global.goblin_scales_amount)
			

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
		"opalall":
			Global.opals_amount += 999 - Global.opals_amount
			emit_signal("opals_obtained", Global.opals_amount)
		"healall":
			Global.hearts += Global.max_hearts - Global.hearts
			emit_signal("life_changed", Global.hearts)
			Global.mana += Global.max_mana - Global.mana
			emit_signal("mana_changed", Global.mana, "Player")
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
	$HurtAnimationPlayer.play("RESET")
	$HurtAnimationPlayer.stop()
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
	is_knocked_back = false
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
		emit_signal("life_changed", Global.hearts, Global.current_character)
		Global.mana += Global.max_mana - Global.mana
		emit_signal("mana_changed", Global.mana, Global.current_character)
		Global.lifewine_amount -= 1
		emit_signal("lifewine_obtained", Global.lifewine_amount)

func _on_ManaHealTimer_timeout():
	is_healing = false
	if Global.manapot_amount > 0 and Global.mana < Global.max_mana:
		Global.mana += Global.max_mana - Global.mana
		emit_signal("mana_changed", Global.mana, Global.current_character)
		Global.manapot_amount -= 1
		emit_signal("manapot_obtained", Global.manapot_amount)
func _on_AnimationPlayer_animation_finished(anim_name):
	$SwordSprite.visible = false
func _on_GlideTimer_timeout():
	if is_gliding and glider_equipped:
		Global.mana -= 1
		emit_signal("mana_changed", Global.mana, Global.current_character)

	if Global.mana >= 1 and glider_equipped:
		$GlideTimer.start()
	else:
		is_gliding = false
		Input.action_release("jump")
	
func _on_MeleeTimer_timeout():
	pass # Replace with function body.
func _on_OxygenTimer_timeout():
	$OxygenBar.value -= 5
	if underwater:
		$OxygenTimer.start()
func _on_OxygenRefillTimer_timeout():
	if !underwater and $OxygenBar.value < 100 and $OxygenTimer.is_stopped():
		$OxygenBar.value += 10
		$OxygenRefillTimer.start()

func on_campfire_toggled():
	is_healing = true
	$CampfireTimer.start()

func _on_CampfireTimer_timeout():
	Global.hearts += Global.max_hearts - Global.hearts
	emit_signal("life_changed", Global.hearts)
	is_healing = false


func _on_AirborneTimer_timeout():

	airborne_mode = false
#	velocity.y = 0
	

func _on_AirborneMaxDuration_timeout():

	Input.action_release("charge")
	velocity.y = 0
	airborne_mode = false
	



func _on_EnemyEvasionArea_area_exited(area):
	if Global.current_character == "Player":
		if is_dashing and area.is_in_group("Hostile"):
			is_invulnerable = true
			
			Input.action_release("charge")
			emit_signal("perfect_dash")
			Engine.time_scale = 0.5
			yield(get_tree().create_timer(0.5), "timeout")
			Engine.time_scale = 1.0
			var tempus_targus = TEMPUS_TARGUS.instance()
			tempus_targus.duration = 5.0
			get_parent().add_child(tempus_targus)
			tempus_targus.position = global_position
			
	#		knock_airborne(area, 4)
	#		Input.action_press("jump")
	#
	#		yield(get_tree().create_timer(1), "timeout")
	#		Input.action_release("jump")
	#		airborne_mode = true
			is_invulnerable = false
		elif !is_dashing and area.is_in_group("Enemy"):
			perfect_dash = false
		



func _on_EnemyEvasionArea_area_entered(area):
	if area.is_in_group("Hostile"):
		perfect_dash = true

#func detect_hostile_attack():
#	var areas = $EnemyEvasionArea.get_overlapping_areas()
#	for a in areas:
#		if a.is_in_group("Hostile"):
#			perfect_dash = true
#		else:
#			perfect_dash = false
#		break
#func enemy_on_left_detector():
#	for a in $LeftAutoAim.get_overlapping_areas():
#		if a.is_in_group("Enemy"):
#			return true
#			break
#	return false
#
#func enemy_on_right_detector():
#	for a in $RightAutoAim.get_overlapping_areas():
#		if a.is_in_group("Enemy"):
#			return true
#			break
#	return false

#func _on_LeftAutoAim_area_entered(area):
#	pass
#
#func _on_RightAutoAim_area_entered(area):
#	if area.is_in_group("Enemy") and $Sprite.flip_h and Input.is_action_just_pressed("ui_attack"):
#		pass
	





func _on_AttackCollision_area_exited(area):
	if area.is_in_group("Enemy"):
		attack_area_overlaps_enemy = false


func _on_InputPressTimer_timeout():
	if !Input.is_action_pressed("ui_dash"):
		if Input.is_action_pressed("ui_up"):
			upwards_charged_attack()
		elif attack_string_count < 2 and !Input.is_action_pressed("ui_up"):
			thrust_attack()
		else:
			charged_attack()
			

