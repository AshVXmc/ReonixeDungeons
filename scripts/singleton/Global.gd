extends Node 

# GLOBALLY ACCESSED VARIABLES
var max_hearts : float = 4
var hearts : float = max_hearts
var max_mana : int = 5
var mana : int = max_mana
var healthpot_amount : int = 0
var macaron_amount : int = 0
var unopened_chests : Array = ["Level1_chest"]
const SAVE_DIR : String = "user://savedata/"
var savepath : String = SAVE_DIR + "savefile.dat"

var dash_unlocked : bool = false


func reset_player_data():
	Global.hearts = 4
	Global.mana = 5
	Global.healthpot_amount = 0
	Global.dash_unlocked = false
	Global.macaron_amount = 0
	unopened_chests.insert(0, "Level1_chest")

func save_player_data():
	var dir : Directory = Directory.new()
	if !dir.dir_exists(SAVE_DIR):
		dir.make_dir_recursive(SAVE_DIR)

	var load_data : Dictionary = {
		"Level" : get_tree().get_current_scene().get_name() ,
		"MaxHealth": Global.max_hearts ,
		"Health" : Global.hearts ,
		"MaxMana" : Global.max_mana ,
		"Mana" : Global.mana ,
		"Healthpot": Global.healthpot_amount ,
		"ChestUnopened": Global.unopened_chests,
		"DashUnlocked" : Global.dash_unlocked
	}

	var savefile : File = File.new()
	var error = savefile.open(savepath, File.WRITE)
	if error == OK:
		savefile.store_var(load_data)
		savefile.close()
	
func mark_opened(opened_chest : String):
	unopened_chests.erase(opened_chest)

func sync_hearts(player_hearts : float):
	player_hearts = Global.hearts
func sync_mana(player_mana : int):
	player_mana = Global.mana
func sync_playerHealthpots(player_healthpot : int):
	player_healthpot = Global.healthpot_amount

