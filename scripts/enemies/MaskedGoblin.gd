class_name MaskedGoblin extends Goblin

var current_state setget set_current_state, get_current_state
enum state  {
	IDLE,
	MELEE_ATTACK
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
var is_dashing : bool = false


func _ready():
	# Overrides
	max_HP = max_HP_calc * 3
	MAX_SPEED *= 1.6
	SPEED = MAX_SPEED
	set_current_state(state.MELEE_ATTACK)
	atk_value = 2.5 * Global.enemy_level_index + 1.25
	set_current_state(state.IDLE)


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
	elif get_current_state() == state.MELEE_ATTACK:
		pass
		
	if $HealthBar.value == $HealthBar.min_value:
		is_dead = true
		$AnimationPlayer.play("Death")
	
	if is_dashing:
		velocity.x = 0
		var dashdirection : int
		dashdirection = LEFT if !$Sprite.flip_h else RIGHT
		velocity.x = SPEED * 500 * dashdirection * delta
		
		
		
func handle_combo_attack_area(combo_id : int):
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
			var enemy_shockwave = preload("res://scenes/enemies/bosses/EnemyShockwave.tscn").instance()
			direction = -1
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
		dash_attack(direction)
#		combo_attack_1(direction)
		$ComboAttack1CooldownTimer.start()



func combo_attack_1(direction : int):
	set_current_state(state.MELEE_ATTACK)
	SPEED = 0
	if direction == LEFT:
		$AnimationPlayer.play("SwordAttackCombo2_Left")
		$AnimationPlayer.queue("SwordAttackCombo1_Left")
		if generate_random_num(0, 1) == 1:
			$AnimationPlayer.queue("SwordAttackCombo3_Left")
		$AnimationPlayer.queue("EndAttackAnimation")
	elif direction == RIGHT:
		$AnimationPlayer.play("SwordAttackCombo2_Right")
		$AnimationPlayer.queue("SwordAttackCombo1_Right")
		if generate_random_num(0, 1) == 1:
			$AnimationPlayer.queue("SwordAttackCombo3_Right")
		$AnimationPlayer.queue("EndAttackAnimation")
		



func dash_attack(dash_direction : int):

#	velocity.x = 0
#	velocity.y = 0
#
#	var correction : int = 1
#	if dash_direction == -1:
#		correction = -1
#	SPEED = MAX_SPEED * 16 * dash_direction * correction
#	yield(get_tree().create_timer(0.6), "timeout")
#	SPEED = MAX_SPEED

	is_dashing = true
	yield(get_tree().create_timer(0.25), "timeout")
	is_dashing = false
	$AnimationPlayer.queue("EndAttackAnimation")
	
func parry_attack():
	pass







