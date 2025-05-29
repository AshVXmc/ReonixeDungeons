class_name MaskedGoblin extends Goblin

const ENEMY_SHOCKWAVE : PackedScene = preload("res://scenes/enemies/bosses/EnemyShockwave.tscn")
const SWORD_PROJECTILE : PackedScene = preload("res://scenes/enemies/bosses/MaskedGoblinSwordProjectile.tscn")
var current_state setget set_current_state, get_current_state
enum state  {
	IDLE,
	MELEE_ATTACK,
	DASHING,
	PARRYING
}
enum {
	LEFT = -1, RIGHT = 1
}
enum ATTACK_PROBABILITY_WEIGHTS  {
	COMBO_ATTACK_1 = 0
	DASH_ATTACK = 2
	PARRY_ATTACK = 0
}

onready var player : Player = get_parent().get_node("Player")
onready var boss_hp_bar_ui : Control = get_parent().get_node("BossHealthBarUI/Control")

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
	max_HP = max_HP_calc * 2
	HP = max_HP
	$HealthBar.max_value = max_HP
	$HealthBar.value = $HealthBar.max_value
	MAX_SPEED *= 1
	SPEED = MAX_SPEED
	set_current_state(state.MELEE_ATTACK)
	atk_value = 1.5 * Global.enemy_level_index + 1
	set_current_state(state.IDLE)
	
	phys_res = 0
	fire_res = -33.3
	ice_res = 0
	earth_res = 0
	
	boss_hp_bar_ui.get_node("HealthBar").max_value = max_HP
	boss_hp_bar_ui.get_node("HealthBar").value = max_HP
	boss_hp_bar_ui.get_node("BossNameLabel").bbcode_text += "Masked Goblin"

func _physics_process(delta):
	if !$Sprite.flip_h:
		$PlayerDetector.set_scale(Vector2(1,1))
	else:
		$PlayerDetector.set_scale(Vector2(-1,1))
	
	boss_hp_bar_ui.get_node("HealthBar").value = HP
	
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
	if get_current_state() == state.MELEE_ATTACK:
		pass
		
	if $HealthBar.value == $HealthBar.min_value:
		is_dead = true
		$AnimationPlayer.play("Death")
	
	if get_current_state() == state.DASHING:
		velocity.x = 0
		var dashdirection : int
		dashdirection = LEFT if !$Sprite.flip_h else RIGHT
		velocity.x = SPEED * 600 * dashdirection * delta
	
	if get_current_state() == state.PARRYING:
		velocity.x = 0
		if is_staggered:
			retaliate(LEFT) if !$Sprite.flip_h else retaliate(RIGHT)
			is_staggered = false
	
	
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
			enemy_shockwave.set_form(enemy_shockwave.SHOCKWAVE)
			get_parent().add_child(enemy_shockwave)
			enemy_shockwave.position = Vector2(global_position.x, global_position.y + 16)
		4:
			for g in $Area2D.get_groups():
				if g != "Enemy":
					$Area2D.remove_from_group(g)
			$Area2D.add_to_group(str(atk_value * 1.5))
			var enemy_shockwave = ENEMY_SHOCKWAVE.instance()
			enemy_shockwave.direction = direction
#			direction = -1
			enemy_shockwave.set_form(enemy_shockwave.SLASHWAVE)
			get_parent().add_child(enemy_shockwave)
			enemy_shockwave.position = Vector2(global_position.x, global_position.y + 16)

func handle_dash_attack_area(direction : int):
	for g in $Area2D.get_groups():
		if g != "Enemy":
			$Area2D.remove_from_group(g)
	$Area2D.add_to_group(str(atk_value * 2))


# utility function for animationplayer
func end_attack_animation():
	# pause for a bit after attacking.
	$PauseAfterAttackingTimer.start()
	$AttackCooldownTimer.start()
	set_current_state(state.IDLE)

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
	SPEED = MAX_SPEED * 1.35
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



func summon_sword_projectiles_attack():
	var sword_projectile : MaskedGoblinSwordProjectile = SWORD_PROJECTILE.instance()
	
	
	
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
	$AnimationPlayer.stop()
	if retaliate_direction == LEFT:
		$AnimationPlayer.play("SwordRetaliate_Left")
	elif retaliate_direction == RIGHT:
		$AnimationPlayer.play("SwordRetaliate_Right")
#	$AnimationPlayer.queue("EndAttackAnimation")







