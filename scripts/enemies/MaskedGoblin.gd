class_name MaskedGoblin extends Goblin

var current_state
const ENEMY_SHOCKWAVE : PackedScene = preload("res://scenes/enemies/bosses/EnemyShockwave.tscn")
enum state  {
	IDLE,
	MELEE_ATTACK
}

func _ready():
	# Overrides
	max_HP = max_HP_calc * 0.75
	SPEED = MAX_SPEED / 4
	current_state = state.IDLE
	atk_value = 2.5 * Global.enemy_level_index + 1.25
func _physics_process(delta):
	if current_state == state.IDLE:
		if !$Sprite.flip_h:
			$AnimationPlayer.play("SwordIdleLeft")
		else:
			$AnimationPlayer.play("SwordIdleRight")

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
			var enemy_shockwave = ENEMY_SHOCKWAVE.instance()
			get_parent().add_child(enemy_shockwave)
			if !$Sprite.flip_h:
				direction = -1
			enemy_shockwave.position = global_position
			
			
			
		
## attack combos
# 1: simple slash
# 2: simple slash 2
# 3: slam to produce shockwaves
# 4: throw sword like boomerang (maybe he can tp to it?)
