class_name MaskedGoblin extends Goblin

var current_state
enum state  {
	IDLE,
	MELEE_ATTACK
}

func _ready():
	# Overrides
	max_HP = max_HP_calc * 0.75
	SPEED = MAX_SPEED / 4
	current_state = state.IDLE

func _physics_process(delta):
	if current_state == state.IDLE:
		if !$Sprite.flip_h:
			$AnimationPlayer.play("SwordIdleLeft")
		else:
			$AnimationPlayer.play("SwordIdleRight")

## attack combos
# 1: simple slash
# 2: simple slash 2
# 3: slam to produce shockwaves
# 4: throw sword like boomerang (maybe he can tp to it?)
