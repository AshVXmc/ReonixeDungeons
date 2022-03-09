extends Node 

# GLOBALLY ACCESSED VARIABLES
var max_hearts : float = 2
var hearts : float = max_hearts
var max_mana : int = 5
var mana : int = max_mana
var healthpot_amount : int = 0
var lifewine_amount : int = 0
var manapot_amount : int = 0
var opals_amount : int = 0
var crystals_amount : int = 0
var opened_chests := []
var soul_token_amount : int = 0
const SAVE_DIR : String = "user://savedata/"
var dash_unlocked : bool = false # 1 mana per use
var glide_unlocked : bool = false # 2 mana per use
var firesaw_unlocked : bool = false # 3 mana per use
var max_item_storage : int = 3
var levelpath : String

var savepath : String = SAVE_DIR + "savefile.dat"
var lighting : bool = true
var vsync : bool = true

# Unsaved conditions
var godmode : bool = false

func reset_player_data():
	Global.hearts = 2
	Global.mana = 5
	Global.healthpot_amount = 0
	Global.lifewine_amount = 0
	Global.manapot_amount = 0
	Global.opals_amount = 0
	Global.crystals_amount = 0
	Global.soul_token_amount = 0
	Global.dash_unlocked = false
	Global.glide_unlocked = false
	Global.firesaw_unlocked = false
	Global.max_item_storage = 3
	Global.lighting = true


func reset_chest_data():
	# Clears the array cache and refill 
	if !Global.opened_chests.empty():
		Global.opened_chests.clear()


func save_player_data():
	var dir : Directory = Directory.new()
	if !dir.dir_exists(SAVE_DIR):
		dir.make_dir_recursive(SAVE_DIR)

	var load_data : Dictionary = {
		"Level" : Global.levelpath,
		"MaxHealth": Global.max_hearts ,
		"Health" : Global.hearts ,
		"MaxMana" : Global.max_mana ,
		"Mana" : Global.mana ,
		"Healthpot": Global.healthpot_amount ,
		"LifeWine" : Global.lifewine_amount,
		"Manapot":  Global.manapot_amount,
		"Opals" : Global.opals_amount ,
		"RevivementCrystals" : Global.crystals_amount,
		"SoulTokens": Global.soul_token_amount,
		"DashUnlocked" : Global.dash_unlocked ,
		"GlideUnlocked" : Global.glide_unlocked,
		"FireSawUnlocked": Global.firesaw_unlocked,
		"ChestOpened": Global.opened_chests,
		"MaxItemStorage":  Global.max_item_storage, 
		"Lighting" : Global.lighting,
		"Vsync" : Global.vsync
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
func sync_playerCrystals(player_crystals : int):
	player_crystals = Global.crystals_amount
# Unused
#func sync_playerSoultokens(player_soul_tokens : int):
#	player_soul_tokens = Global.soul_token_amount

	


