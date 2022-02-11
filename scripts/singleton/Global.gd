extends Node 

# GLOBALLY ACCESSED VARIABLES
var max_hearts : float = 2
var hearts : float = max_hearts
var max_mana : int = 4
var mana : int = max_mana
var healthpot_amount : int = 0
var lifewine_amount : int = 0
var manapot_amount : int = 0
var opals_amount : int = 0
var unopened_chests := ["Level1_chest"]
const SAVE_DIR : String = "user://savedata/"
var savepath : String = SAVE_DIR + "savefile.dat"
var dash_unlocked : bool = false
var glide_unlocked : bool = false
var max_item_storage : int = 3
# Unsaved conditions
var godmode : bool = false

func reset_player_data():
	# Default player data
	Global.hearts = 2
	Global.mana = 4
	Global.healthpot_amount = 2
	Global.lifewine_amount = 1
	Global.manapot_amount = 1
	Global.opals_amount = 0
	Global.dash_unlocked = false
	Global.glide_unlocked = false
	Global.max_item_storage = 3
	

func reset_chest_data():
	# Clears the array cache and refill anually
	if !Global.unopened_chests.empty():
		Global.unopened_chests.clear()
		Global.unopened_chests.insert(0, "Level1_chest")
#		Global.unopened_chests.insert(1, "Level2_chest")

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
		"LifeWine" : Global.lifewine_amount,
		"Manapot":  Global.manapot_amount,
		"Opals" : Global.opals_amount ,
		"DashUnlocked" : Global.dash_unlocked ,
		"GlideUnlocked" : Global.glide_unlocked,
		"ChestUnopened": Global.unopened_chests,
		"MaxItemStorage":  Global.max_item_storage
	}

	var savefile : File = File.new()
	var error = savefile.open(savepath, File.WRITE)
	if error == OK:
		savefile.store_var(load_data)
		savefile.close()

func sync_hearts(player_hearts : float):
	player_hearts = Global.hearts
func sync_mana(player_mana : int):
	player_mana = Global.mana
func sync_playerHealthpots(player_healthpot : int):
	player_healthpot = Global.healthpot_amount
func sync_playerLifeWines(player_lifewine : int):
	player_lifewine = Global.lifewine_amount
func sync_playerManapots(player_manapot : int):
	player_manapot = Global.manapot_amount
func sync_playerOpals(player_opals : int):
	player_opals = Global.opals_amount

	


