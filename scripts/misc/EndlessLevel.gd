class_name EndlessLevel extends Level
# NAME IDEAS
# The Palace of Trials
var WAVE : int = 1
var STAGE : int = 1
const GOBLIN = preload("res://scenes/enemies/Goblin.tscn")
const BOW_GOBLIN = preload("res://scenes/enemies/BowGoblin.tscn")
const SHAMAN_GOBLIN = preload("res://scenes/enemies/ShamanGoblin.tscn")
const BAT = preload("res://scenes/enemies/Bat.tscn")
const WITCH_GOBLIN = preload("res://scenes/enemies/WitchGoblin.tscn")
const SLIME = preload("res://scenes/enemies/Slime.tscn")
const FIRE_SLIME = preload("res://scenes/enemies/FireSlime.tscn")
# Every member of the array will be spawned in the corresponding position2D node based on their index.
var objective_label_text = "Defeat all enemies ({enemies_left}/{total_enemies})"
var timer_label_text = "Time elapsed: "
var wave_in_progress : bool = false
var challenge_ended : bool = false
var time_elapsed : float 
# e.g: [GOBLIN, BOW_GOBLIN] means a GOBLIN will be spawned in spawnpoint0 and a BOW_GOBLIn will 
# be spawned in spawnpoint1.

# 1 means normal time tick for the stage timer.
# effects like tempus tardus sets the value to 0.2
var time_slow_coefficient : float = 1
const TEMPUS_TARDUS_TIMESLOW : float = 0.2

var wave_batches : Dictionary = {
	1 : {
		1 : [SLIME, SLIME, FIRE_SLIME, FIRE_SLIME],
		2: [GOBLIN, BAT, BAT, GOBLIN],
		3: [GOBLIN, SHAMAN_GOBLIN, GOBLIN]
	},
	2: {
		1: [BOW_GOBLIN, GOBLIN, BOW_GOBLIN],
		2: [SHAMAN_GOBLIN, GOBLIN, BOW_GOBLIN],
		3: [WITCH_GOBLIN, GOBLIN]
	}
}


# POINT 0: LEFT PILLAR
# POINT 1: MIDDLE OF ROOM
# POINT 2: RIGHT PILLAR
# POINT 3: LOWER LEFT PLATFORM
# POINT 4: UPPER LEFT PLATFORM
# POINT 5: UPPER RIGHT PLATFORM
# POINT 6: LOWER RIGHT PLATFORM
var wave_spawn_points = {
	1 : {
		1: [0, 2, 3, 6],
		2: [0, 4, 5, 2],
		3: [0, [4,5], 2]
	},
	2 : {
		1: [0, 1, 2],
		2: [[4,5], 0, 2],
		3: [[3,6], [4,5]]
	}
}


func amount_of_alive_enemies():
	var alive_enemies = get_tree().get_nodes_in_group("WaveEnemy")
	return alive_enemies.size()
	
func _process(delta):
	if wave_in_progress and !challenge_ended and WAVE < wave_batches[STAGE].size(): 
		if amount_of_alive_enemies() == 0:
			WAVE += 1
			if WAVE > wave_batches[STAGE].size():
				challenge_ended = true
				end_challenge()
			else:
				initiate_enemy_wave(STAGE, WAVE)
	if wave_in_progress:
		time_elapsed += delta * time_slow_coefficient
		$LevelObjectiveUI.objective_active(
			# Objective label
			objective_label_text.format({
				"enemies_left" : str(wave_batches[STAGE][WAVE].size() - amount_of_alive_enemies()),
				"total_enemies": str(wave_batches[STAGE][WAVE].size())
			}),
			# Timer label
			timer_label_text + ("%02d:%02d" % [time_elapsed / 60, fmod(time_elapsed, 60)]),
			# uses timer
			true
		)
	else:
		$LevelObjectiveUI.objective_inactive()
	

func initiate_enemy_wave(stage : int, wave : int):
	wave_in_progress = true
	var enemy_list = wave_batches[stage][wave]
	for enemy in enemy_list:
		if enemy is PackedScene:
			var e_index : int = enemy_list.find(enemy, 0)
			var e = enemy.instance()
			add_child(e)
			e.add_to_group("WaveEnemy")
			var spawn_pos = wave_spawn_points[stage][wave][e_index]
			if typeof(spawn_pos) == TYPE_INT:
				e.position = get_node("SpawnPoint" + str(spawn_pos)).global_position
			elif typeof(spawn_pos) == TYPE_ARRAY:
				e.position = get_node("SpawnPoint" + str(pick_random_from_array(spawn_pos))).global_position
			enemy_list.remove(e_index)
			enemy_list.insert(e_index, "")
	$LevelObjectiveUI.initiative_wave_ui(wave)

func pick_random_from_array(arr : Array):
	randomize()
	return arr[randi() % arr.size()]

func end_challenge():
	challenge_ended = true
	wave_in_progress = false
	print("CHALLENGE DONE")

