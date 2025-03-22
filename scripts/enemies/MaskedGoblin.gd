class_name MaskedGoblin extends Goblin

const ENEMY_SHOCKWAVE : PackedScene = preload("res://scenes/enemies/bosses/EnemyShockwave.tscn")
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
func set_current_state(new_value : int):
	current_state = new_value
	
	match current_state:
		state.IDLE:
			is_frozen = false
		state.MELEE_ATTACK:
			is_frozen = true

func get_current_state() -> int:
	return current_state

onready var player : Player = get_parent().get_node("Player")



func _ready():
	# Overrides
	max_HP = max_HP_calc * 3
	MAX_SPEED *= 1.6
	SPEED = MAX_SPEED
	set_current_state(state.MELEE_ATTACK)
	atk_value = 2.5 * Global.enemy_level_index + 1.25
	set_current_state(state.IDLE)
	
	phys_res = 0
	fire_res = -33.3
	ice_res = 0
	earth_res = 0


func _physics_process(delta):
	if !$Sprite.flip_h:
		$PlayerDetector.set_scale(Vector2(1,1))
	else:
		$PlayerDetector.set_scale(Vector2(-1,1))
	
	if player in $PlayerDetector.get_overlapping_bodies():
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

# utility function for an animationplayer node
func end_attack_animation():
	set_current_state(state.IDLE)
	SPEED = MAX_SPEED



func generate_random_num(min_value : int, max_value : int) -> int:
	var rng : RandomNumberGenerator = RandomNumberGenerator.new()
	rng.randomize()
	return rng.randi_range(min_value, max_value)


func attack(direction : int):
	if $ComboAttack1CooldownTimer.is_stopped():
#		dash_attack(direction)
		combo_attack_1(direction)
#		parry_attack(direction)
		$ComboAttack1CooldownTimer.start()



func combo_attack_1(direction : int):
	set_current_state(state.MELEE_ATTACK)
	SPEED = 0
	if direction == LEFT:
		$AnimationPlayer.play("SwordAttackCombo2_Left")
		$AnimationPlayer.queue("SwordAttackCombo1_Left")
		if generate_random_num(1, 1) == 1:
			$AnimationPlayer.queue("SwordAttackCombo3_Left")
		$AnimationPlayer.queue("EndAttackAnimation")
	elif direction == RIGHT:
		$AnimationPlayer.play("SwordAttackCombo2_Right")
		$AnimationPlayer.queue("SwordAttackCombo1_Right")
		if generate_random_num(1, 1) == 1:
			$AnimationPlayer.queue("SwordAttackCombo3_Right")
		$AnimationPlayer.queue("EndAttackAnimation")
		



func dash_attack(dash_direction : int):
	set_current_state(state.MELEE_ATTACK)
	if dash_direction == LEFT:
		$AnimationPlayer.play("SwordDashAttack_Left")
	elif dash_direction == RIGHT:
		$AnimationPlayer.play("SwordDashAttack_Right")
	yield(get_tree().create_timer(0.3), "timeout")
	set_current_state(state.DASHING)
	yield(get_tree().create_timer(0.25), "timeout")
	set_current_state(state.IDLE)
	$AnimationPlayer.queue("EndAttackAnimation")


func parry_attack(parry_direction : int):
	set_current_state(state.PARRYING)
	if parry_direction == LEFT:
		$AnimationPlayer.play("SwordParryStance_Left")
	elif parry_direction == RIGHT:
		$AnimationPlayer.play("SwordParryStance_Right")


func retaliate(retaliate_direction : int):
	set_current_state(state.MELEE_ATTACK)
	$AnimationPlayer.stop()
	if retaliate_direction == LEFT:
		$AnimationPlayer.play("SwordRetaliate_Left")
	elif retaliate_direction == RIGHT:
		$AnimationPlayer.play("SwordRetaliate_Right")
	$AnimationPlayer.queue("EndAttackAnimation")





