class_name EndlessLevel extends Level
# NAME IDEAS
# The Palace of Trials
var WAVE : int = 1
const GOBLIN = preload("res://scenes/enemies/Goblin.tscn")
const BOW_GOBLIN = preload("res://scenes/enemies/BowGoblin.tscn")
# Every member of the array will be spawned in the corresponding position2D node based on their index.
var objective_label_text = "Defeat all enemies ({enemies_left}/{total_enemies})"
var timer_label_text = "Time elapsed: "
var wave_in_progress : bool = false
var challenge_ended : bool = false
var time_elapsed : float 
# e.g: [GOBLIN, BOW_GOBLIN] means a GOBLIN will be spawned in spawnpoint0 and a BOW_GOBLIn will 
# be spawned in spawnpoint1.

var wave_batches = {
	1 : [GOBLIN, GOBLIN],
	2: [BOW_GOBLIN,  BOW_GOBLIN]
}

# POINT 0: LEFT PILLAR
# POINT 1: MIDDLE OF ROOM
# POINT 2: RIGHT PILLAR
# POINT 3: LEFT PLATFORM
# POINT 4: MIDDLE LEFT PLATFORM
# POINT 5: MIDDLE RIGHT PLATFORM
# POINT 6: RIGHT PLATFORM
var wave_spawn_points = {
	1: [0, 2],
	2: [0, 2]
}


func amount_of_alive_enemies():
	var alive_enemies = get_tree().get_nodes_in_group("WaveEnemy")
	return alive_enemies.size()
	
func _process(delta):
	if wave_in_progress and !challenge_ended and WAVE < wave_batches.size(): 
		if amount_of_alive_enemies() == 0:
			WAVE += 1
			if WAVE > wave_batches.size():
				challenge_ended = true
				end_challenge()
			else:
				initiate_enemy_wave(WAVE)
	if wave_in_progress:
		time_elapsed += delta
		$LevelObjectiveUI.objective_active(
			# Objective label
			objective_label_text.format({
				"enemies_left" : str(wave_batches[WAVE].size() - amount_of_alive_enemies()),
				"total_enemies": str(wave_batches[WAVE].size())
			}),
			# Timer label
			timer_label_text + ("%02d:%02d" % [time_elapsed / 60, fmod(time_elapsed, 60)]),
			# uses timer
			true
		)
	else:
		$LevelObjectiveUI.objective_inactive()
	

func initiate_enemy_wave(wave : int):
	wave_in_progress = true
	var enemy_list = wave_batches[wave]
	for enemy in enemy_list:
		if enemy is PackedScene:
			var e_index : int = enemy_list.find(enemy, 0)
			var e = enemy.instance()
			add_child(e)
			e.add_to_group("WaveEnemy")
			e.position = get_node("SpawnPoint" + str(wave_spawn_points[wave][e_index])).global_position
			enemy_list.remove(e_index)
			enemy_list.insert(e_index, "")
	$LevelObjectiveUI.initiative_wave_ui(wave)


func end_challenge():
	challenge_ended = true
	wave_in_progress = false
	print("CHALLENGE DONE")

