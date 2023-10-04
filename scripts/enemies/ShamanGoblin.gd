class_name ShamanGoblin extends Goblin


func _ready():
	# Overrides
	max_HP = 15 + (Global.enemy_level_index * 15)
	SPEED = MAX_SPEED / 2.5
