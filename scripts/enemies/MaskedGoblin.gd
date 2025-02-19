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
	


onready var player : Player = get_parent().get_node("Player")


func _ready():
	# Overrides
	max_HP = max_HP_calc * 0.75
	SPEED = MAX_SPEED * 1.35
	set_current_state(state.MELEE_ATTACK)
	atk_value = 2.5 * Global.enemy_level_index + 1.25
	set_current_state(state.IDLE)
	
	
#	yield(get_tree().create_timer(0.5), "timeout")
#	$AnimationPlayer.play("SwordAttackCombo2_Left")
#	$AnimationPlayer.queue("SwordAttackCombo1_Left")
#	$AnimationPlayer.queue("SwordAttackCombo3_Left")
#	$AnimationPlayer.queue("EndAttackAnimation")


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
	SPEED = MAX_SPEED

func combo_attack_1():
	current_state = state.MELEE_ATTACK
	SPEED = 0
	yield(get_tree().create_timer(0.2), "timeout")
	if !$Sprite.flip_h:
		$AnimationPlayer.play("SwordAttackCombo2_Left")
		$AnimationPlayer.queue("SwordAttackCombo1_Left")
	#	$AnimationPlayer.queue("SwordAttackCombo3_Left")
		$AnimationPlayer.queue("EndAttackAnimation")
	else:
		pass

func dash_attack():
	pass

func parry_attack():
	pass


func _on_PlayerDetectorLeft_body_entered(body):
	if current_state == state.IDLE and body.is_in_group("PlayerEntity") and $ComboAttack1CooldownTimer.is_stopped():
		combo_attack_1()
		$ComboAttack1CooldownTimer.start()

func _on_PlayerDetectorRight_body_entered(body):
	pass # Replace with function body.
