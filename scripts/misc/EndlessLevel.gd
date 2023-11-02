class_name EndlessLevel extends Level

var WAVE : int = 1
const GOBLIN = preload("res://scenes/enemies/Goblin.tscn")
# Every member of the array will be spawned in the corresponding position2D node based on their index.

# e.g: [GOBLIN, BOW_GOBLIN] means a GOBLIN will be spawned in spawnpoint0 and a BOW_GOBLIn will 
# be spawned in spawnpoint1.

var wave_batches = {
	1 : [GOBLIN, GOBLIN]
}

func _ready():
	initiate_enemy_wave(1)


func initiate_enemy_wave(wave : int):
	var enemy_list = wave_batches[wave]
	for enemy in enemy_list:
		if enemy is PackedScene:
			var e_index : int = enemy_list.find(enemy, 0)
			var e = enemy.instance()
			add_child(e)
			e.position = get_node("SpawnPoint" + str(e_index)).global_position
			enemy_list.remove(e_index)
			enemy_list.insert(e_index, "")
