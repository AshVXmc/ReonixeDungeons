class_name MaskedGoblin extends Goblin

var current_state setget set_current_state, get_current_state
enum state  {
	IDLE,
	MELEE_ATTACK
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
	
	


func _ready():
	# Overrides
	max_HP = max_HP_calc * 0.75
	SPEED = MAX_SPEED 
	set_current_state(state.MELEE_ATTACK)
	atk_value = 2.5 * Global.enemy_level_index + 1.25
	yield(get_tree().create_timer(0.5), "timeout")
	$AnimationPlayer.play("SwordAttackCombo2_Left")
#	yield(get_tree().create_timer(0.25), "timeout")
	$AnimationPlayer.queue("SwordAttackCombo1_Left")
#	yield(get_tree().create_timer(0.25), "timeout")
	$AnimationPlayer.queue("SwordAttackCombo3_Left")
	$AnimationPlayer.queue("EndAttackAnimation")
func _physics_process(delta):
	if get_current_state() == state.IDLE:
		if !$Sprite.flip_h:
			$AnimationPlayer.play("SwordIdleLeft")
		else:
			$AnimationPlayer.play("SwordIdleRight")
	elif get_current_state() == state.MELEE_ATTACK:
		pass

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
			
		
## attack combos
# 1: simple slash
# 2: simple slash 2
# 3: slam to produce shockwaves
# 4: throw sword like boomerang (maybe he can tp to it?)
