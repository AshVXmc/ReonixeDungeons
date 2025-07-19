class_name MaskedGoblin extends Goblin

const ENEMY_SHOCKWAVE : PackedScene = preload("res://scenes/enemies/bosses/EnemyShockwave.tscn")
const SWORD_PROJECTILE : PackedScene = preload("res://scenes/enemies/bosses/MaskedGoblinSwordProjectile.tscn")
const MAX_STAGGER : int = 40
const STAGGERED_STATE_GLOBAL_RES_SHRED : int = 20
const SUMMON_SWORD_POSITIONS : Array = [1,2,3,4,5,6,7,8,9]
var stagger_value : int = MAX_STAGGER
var current_state setget set_current_state, get_current_state
var current_phase : int = 1

enum state  {
	IDLE,
	STAGGERED,
	MELEE_ATTACK,
	DASHING,
	PARRYING
}
enum {
	LEFT = -1, RIGHT = 1
}
enum ATTACK_PROBABILITY_WEIGHTS  {
	COMBO_ATTACK_1 = 0
	DASH_ATTACK = 0
	PARRY_ATTACK = 1
	SUMMON_SWORD_PROJECTILES_ATTACK = 0
}

onready var player = get_parent().get_node("Player")
onready var boss_hp_bar_ui : BossHealthBar = get_parent().get_node("BossHealthBarUI/Control")

var is_being_attacked : bool = false
var is_dead : bool = false

# utility functions start
func set_current_state(new_value : int):
	current_state = new_value
	
	match current_state:
		state.IDLE:
			is_frozen = false
		state.MELEE_ATTACK:
			is_frozen = true

func get_current_state() -> int:
	return current_state

func generate_random_num(min_value : int, max_value : int) -> int:
	var rng : RandomNumberGenerator = RandomNumberGenerator.new()
	rng.randomize()
	return rng.randi_range(min_value, max_value)
# utility functions end


func _ready():
	# Overrides
	max_HP = max_HP_calc * 8
	HP = max_HP
	$HealthBar.max_value = max_HP
	$HealthBar.value = $HealthBar.max_value
	MAX_SPEED *= 1.1
	SPEED = MAX_SPEED
	set_current_state(state.MELEE_ATTACK)
	atk_value = 1.3 * Global.enemy_level_index + 1
	set_current_state(state.IDLE)
	
	boss_hp_bar_ui.set_max_health_bar_value(max_HP)
	boss_hp_bar_ui.set_health_bar_value(max_HP)
	boss_hp_bar_ui.set_stagger_bar_max_value(MAX_STAGGER)
	boss_hp_bar_ui.set_stagger_bar_value(MAX_STAGGER)
	boss_hp_bar_ui.set_boss_name("Masked Goblin", level)
	
	phys_res = -20
	fire_res = -20
	ice_res = 0
	earth_res = 0
	global_res = 0
	weaknesses = ["Physical", "Fire"]
	for w in weaknesses:
		boss_hp_bar_ui.add_weakness_display(w)
	
	$PlayerDetector/CollisionShape2D.disabled = false


func _physics_process(delta):
	if !$Sprite.flip_h:
		$PlayerDetector.set_scale(Vector2(1,1))
#		$ParryDetectorArea2D.set_scale(Vector2(1,1))
	else:
		$PlayerDetector.set_scale(Vector2(-1,1))
#		$ParryDetectorArea2D.set_scale(Vector2(-1,1))
	boss_hp_bar_ui.set_health_bar_value(HP)
	
	if player in $PlayerDetector.get_overlapping_bodies() and get_current_state() == state.IDLE and $AttackCooldownTimer.is_stopped():
		if !$Sprite.flip_h:
			attack(LEFT)
		else:
			attack(RIGHT)
	
	if get_current_state() == state.IDLE:
		if !$Sprite.flip_h:
			$AnimationPlayer.play("SwordIdleLeft")
		else:
			$AnimationPlayer.play("SwordIdleRight")
		
	if $HealthBar.value == $HealthBar.min_value:
		is_dead = true
		$AnimationPlayer.play("Death")
	
	if get_current_state() == state.STAGGERED:
		velocity.x = 0
	if get_current_state() == state.DASHING:
		velocity.x = 0
		var dashdirection : int
		dashdirection = LEFT if !$Sprite.flip_h else RIGHT
		velocity.x = SPEED * 600 * dashdirection * delta
	
	if get_current_state() == state.PARRYING:
		velocity.x = 0
		if is_being_attacked:
			retaliate(LEFT) if !$Sprite.flip_h else retaliate(RIGHT)
			is_being_attacked = false
	
	
func handle_combo_attack_area(combo_id : int, direction : int):
	match combo_id:
		1:
			for g in $Area2D.get_groups():
				if g != "Enemy":
					$Area2D.remove_from_group(g)
			$Area2D.add_to_group(str(atk_value))
		2:
			for g in $Area2D.get_groups():
				if g != "Enemy":
					$Area2D.remove_from_group(g)
			$Area2D.add_to_group(str(atk_value * 1.25))
		3:
			for g in $Area2D.get_groups():
				if g != "Enemy":
					$Area2D.remove_from_group(g)
			$Area2D.add_to_group(str(atk_value * 1.5))
			var enemy_shockwave = ENEMY_SHOCKWAVE.instance()
			enemy_shockwave.direction = -direction 
			print("current direction: " + str(direction))
#			enemy_shockwave.set_form(enemy_shockwave.SHOCKWAVE)
			get_parent().add_child(enemy_shockwave)
			enemy_shockwave.position = Vector2(global_position.x + (200 * direction), global_position.y + 16)
		4:
			for g in $Area2D.get_groups():
				if g != "Enemy":
					$Area2D.remove_from_group(g)
			$Area2D.add_to_group(str(atk_value * 1.5))
			var enemy_shockwave = ENEMY_SHOCKWAVE.instance()
			enemy_shockwave.direction = direction
#			direction = -1
#			enemy_shockwave.set_form(enemy_shockwave.SLASHWAVE)
			get_parent().add_child(enemy_shockwave)
			enemy_shockwave.position = Vector2(global_position.x + (200 * direction), global_position.y + 16)

func handle_dash_attack_area(direction : int):
	for g in $Area2D.get_groups():
		if g != "Enemy":
			$Area2D.remove_from_group(g)
	$Area2D.add_to_group(str(atk_value * 2))


# utility function for animationplayer
func end_attack_animation():
	# pause for a bit after attacking.
	if get_current_state() != state.STAGGERED:
		$PauseAfterAttackingTimer.start()
		$AttackCooldownTimer.start()
#	set_current_state(state.IDLE)

func _on_PauseAfterAttackingTimer_timeout():
	set_current_state(state.IDLE)
	SPEED = MAX_SPEED

	
# OVERRIDE
func parse_damage(staggers : bool = true):
#	if staggers:
#		is_staggered = true
	emit_signal("change_hitcount", 1)
	$Sprite.set_modulate(Color(1.4,0.5,0.3,1))
	if $HurtTimer.is_stopped():
		$HurtTimer.start()
	if HP <= 0:
		$Area2D/CollisionShape2D.disabled = true
		$CollisionShape2D.disabled = true
		$Left/CollisionShape2D.disabled = true
		$Right/CollisionShape2D.disabled = true
		dead = true
		$AnimationPlayer.play("Death")
# OVERRIDE
func knockback(knockback_coefficient : float = 1):
#	is_staggered = true
#	if $Sprite.flip_h:
#		velocity.x = -SPEED * knockback_coefficient
#	else:
#		velocity.x = SPEED * knockback_coefficient
#	$HurtTimer.start()
	pass

# OVERRIDE
func _on_Area2D_area_entered(area):
	# call the function, else the override will exclude the code in the parent function.
	._on_Area2D_area_entered(area) 
	
	# add code to the function instead of overriding everything
	if get_current_state() != state.STAGGERED:
		if stagger_value <= 0:
			enter_staggered_state()
		else:
			# physical and fire weakness reduce the stagger bar
			if area.is_in_group("Sword") or area.is_in_group("Fireball") or area.is_in_group("LightPoiseDamage") or area.is_in_group("MediumPoiseDamage"):
				stagger_value -= 1
			elif area.is_in_group("HeavyPoiseDamage") or area.is_in_group("SwordCharged"):
				stagger_value -= 3
				
			boss_hp_bar_ui.set_stagger_bar_value(stagger_value)

func enter_staggered_state():
	is_staggered = true
	set_current_state(state.STAGGERED)
	global_res -= STAGGERED_STATE_GLOBAL_RES_SHRED
	$StunnedParticle.visible = true
	$StunnedParticle.play = true
#	$AnimationPlayer.stop()
	$AttackArea2D/CollisionShape2D.disabled = true
	$AttackingTimer.stop()
	$PauseAfterAttackingTimer.stop()
	$AttackCooldownTimer.stop()
	$StaggeredTimer.start()
	if !$Sprite.flip_h:
		$AnimationPlayer.play("StaggeredLeft")
	else:
		$AnimationPlayer.play("StaggeredRight")

func _on_StaggeredTimer_timeout():
	exit_staggered_state()

func exit_staggered_state():
	is_staggered = false
	global_res += STAGGERED_STATE_GLOBAL_RES_SHRED
	$AnimationPlayer.stop() # stop the staggered animation
	$StunnedParticle.visible = false
	$StunnedParticle.play = false
	stagger_value = MAX_STAGGER
	boss_hp_bar_ui.set_stagger_bar_value(stagger_value)
	set_current_state(state.IDLE)
	$AttackingTimer.start()
	

func attack(direction : int):
	if $AttackCooldownTimer.is_stopped():
		set_current_state(state.MELEE_ATTACK)
		SPEED = 0
		$AttackIndicatorFlashSprite.visible = true
		$AttackIndicatorFlashSprite.play("flash")
		yield(get_tree().create_timer(0.5), "timeout")
		$AttackIndicatorFlashSprite.visible = false
		
		var weight_sum : int = 0
		var chosen_move : String 
		for w in ATTACK_PROBABILITY_WEIGHTS:
			weight_sum += ATTACK_PROBABILITY_WEIGHTS[w]
		
		var num : int = generate_random_num(0, weight_sum - 1)
		for w in ATTACK_PROBABILITY_WEIGHTS:
			if num < ATTACK_PROBABILITY_WEIGHTS[w]:
				chosen_move = w
				break
			num -= ATTACK_PROBABILITY_WEIGHTS[w]
		
		match chosen_move:
			"COMBO_ATTACK_1":
				combo_attack_1(direction)
			"DASH_ATTACK":
				dash_attack(direction)
			"PARRY_ATTACK":
				parry_attack(direction)
			"SUMMON_SWORD_PROJECTILES_ATTACK":
				summon_sword_projectiles_attack()
				


func on_attack_indicator_flash_animation_finished():
	pass


func combo_attack_1(direction : int):
	set_current_state(state.MELEE_ATTACK)
	SPEED = 0
	if direction == LEFT:
		$AnimationPlayer.play("SwordAttackCombo2_Left")
		$AnimationPlayer.queue("SwordAttackCombo1_Left")
		if generate_random_num(1, 1) == 1:
			$AnimationPlayer.queue("SwordAttackCombo3_Left")
#		$AnimationPlayer.queue("EndAttackAnimation")
	elif direction == RIGHT:
		$AnimationPlayer.play("SwordAttackCombo2_Right")
		$AnimationPlayer.queue("SwordAttackCombo1_Right")
		if generate_random_num(1, 1) == 1:
			$AnimationPlayer.queue("SwordAttackCombo3_Right")
#		$AnimationPlayer.queue("EndAttackAnimation")
		
func dash_attack(dash_direction : int):
	set_current_state(state.MELEE_ATTACK)
	if dash_direction == LEFT:
		$AnimationPlayer.play("SwordDashAttack_Left")
	elif dash_direction == RIGHT:
		$AnimationPlayer.play("SwordDashAttack_Right")
#	$AnimationPlayer.queue("EndAttackAnimation")

# utility function for animationplayer.
func set_dash_movement():
	var tempus_tardus_slowing_factor : int = 1
	if is_in_tempus_tardus:
		tempus_tardus_slowing_factor = 0.05
	SPEED = MAX_SPEED * 1.25
	set_current_state(state.DASHING)

func stop_dash_movement():
	SPEED = 0
#	set_current_state(state.MELEE_ATTACK)
#	yield(get_tree().create_timer(0.2), "timeout")
#	if dash_direction == LEFT:
#		$AnimationPlayer.play("SwordDashAttack_Left")
#		SPEED = MAX_SPEED * 1.35
#	elif dash_direction == RIGHT:
#		$AnimationPlayer.play("SwordDashAttack_Right")
#		SPEED = MAX_SPEED * 1.35
#	yield(get_tree().create_timer(0.1), "timeout")
#	set_current_state(state.DASHING)
#	yield(get_tree().create_timer(0.25), "timeout")
#	$AnimationPlayer.queue("EndAttackAnimation")
#	end_attack_animation()


func summon_sword_projectiles_attack(sword_amount : int = 4, wave_count : int = 2):
	while wave_count > 0:
		var summon_sword_positions : Array = SUMMON_SWORD_POSITIONS.duplicate()
		var summon_sword_amount : int = sword_amount
		randomize()
		summon_sword_positions.shuffle()
		while summon_sword_amount > 0:
			var enemy_sword_projectile = SWORD_PROJECTILE.instance()
			var position_index : int = summon_sword_positions.pop_back()
			# for some reason, using get_parent().add_child() makes it not work.
			enemy_sword_projectile.atk_value = atk_value 
			add_child(enemy_sword_projectile)
			enemy_sword_projectile.global_position = get_parent().get_node("Position2D_" + str(position_index)).global_position
			summon_sword_amount -= 1
		wave_count -= 1
		yield(get_tree().create_timer(1.5), "timeout")
		
	yield(get_tree().create_timer(1.35), "timeout")
	end_attack_animation()


func parry_attack(parry_direction : int):
	set_current_state(state.PARRYING)
	SPEED = 0
	if parry_direction == LEFT:
		$AnimationPlayer.play("SwordParryStance_Left")
	elif parry_direction == RIGHT:
		$AnimationPlayer.play("SwordParryStance_Right")


func retaliate(retaliate_direction : int):
	set_current_state(state.MELEE_ATTACK)
	SPEED = 0
	is_being_attacked = false
	$AnimationPlayer.stop()
	if retaliate_direction == LEFT:
		$AnimationPlayer.play("SwordRetaliate_Left")
	elif retaliate_direction == RIGHT:
		$AnimationPlayer.play("SwordRetaliate_Right")
#	$AnimationPlayer.queue("EndAttackAnimation")


func _on_ParryDetectorArea2D_area_entered(area):
	if area.is_in_group("Sword") or area.is_in_group("SwordCharged") or area.is_in_group("Fireball") or area.is_in_group("Ice") or area.is_in_group("Earth") or area.is_in_group("Lightning"):
		is_being_attacked = true
		print("PARRY DETECTED")


