extends Node 

# GLOBALLY ACCESSED VARIABLES
var max_hearts : float = 3
var hearts : float = max_hearts
var max_mana : int = 6
var mana : int = max_mana
var attack_power : int = 5
var healthpot_amount : int = 0
var lifewine_amount : int = 0
var manapot_amount : int = 0
var opals_amount : int = 0
var common_monster_dust_amount : int = 0
var goblin_scales_amount : int = 0
var crystals_amount : int = 0
var opened_chests := []
var soul_token_amount : int = 0
const SAVE_DIR : String = "user://savedata/"
var dash_unlocked : bool = true # 1 mana per use
var glide_unlocked : bool = false # 1 mana per use
var firesaw_unlocked : bool = true # 3 mana per use
var fire_fairy_unlocked : bool = true # 1 mana per second of usage
var max_item_storage : int = 5
var levelpath : String
var is_loading_a_save : bool
var player_position : Vector2
var savepath : String = SAVE_DIR + "savefile.dat"
var lighting : bool = false
var vsync : bool = false
var activated_portals : Array
var enemy_level_index : int = 1

# Skills that the player currently equips
var player_skills : Dictionary = {
	"PrimarySkill" : null,
	"SecondarySkill" : null,
	"RangedSkill" : null
}

# The level of skills. Higher levels = more damage and utility etc etc
var skill_levels : Dictionary = {
	"FireSawLevel": 1,
	"FireFairyLevel": 1,
	"FireballLevel": 1
}

# List of skills (Unlocked and locked)
var list_of_skills : Dictionary = {
	"PrimarySkill": ["FireSaw"], 
	"SecondarySkill": ["FireFairy", "FrostBlast"],
	"RangedSkill": ["Fireball"]
}

# List of unlocked skills
var unlocked_skills : Dictionary = {
	"PrimarySkills": ["FireSaw"],
	"SecondarySkills": ["FireFairy"],
	"RangedSkills": ["Fireball"]
}




var enemies_killed : int
# Boss Victories
var masked_goblin_defeated : bool

# Unsaved conditions
var godmode : bool = false

	
func reset_player_data():
	Global.hearts = 3
	Global.mana = 6
	Global.healthpot_amount = 0
	Global.lifewine_amount = 0
	Global.manapot_amount = 0
	Global.opals_amount = 0
	Global.crystals_amount = 0
	Global.common_monster_dust_amount = 0
	Global.goblin_scales_amount = 0
	Global.soul_token_amount = 0
	Global.dash_unlocked = true
	Global.glide_unlocked = false
	Global.firesaw_unlocked = true
	Global.fire_fairy_unlocked = true
	Global.is_loading_a_save = false
	Global.max_item_storage = 5
	Global.lighting = true
	Global.levelpath = ""
	Global.enemies_killed = 0
	Global.masked_goblin_defeated = false
	Global.player_skills["PrimarySkill"] = "FireSaw"
	Global.player_skills["SecondarySkill"] = "FireFairy"
	Global.player_skills["RangedSkill"] = "Fireball"
	Global.vsync = false
	Global.activated_portals.clear()
	
func reset_chest_data():
	# Clears the array cache and refill 
	if !Global.opened_chests.empty():
		Global.opened_chests.clear()


func save_player_data():
	var dir : Directory = Directory.new()
	if !dir.dir_exists(SAVE_DIR):
		dir.make_dir_recursive(SAVE_DIR)
	Global.is_loading_a_save = true
	var load_data : Dictionary = {
		"Level" : Global.levelpath,
		"MaxHealth": Global.max_hearts ,
		"Health" : Global.hearts ,
		"MaxMana" : Global.max_mana ,
		"Mana" : Global.mana ,
		"AttackPower": Global.attack_power,
		"EnemyLevelIndex": Global.enemy_level_index,
		"Healthpot": Global.healthpot_amount ,
		"LifeWine" : Global.lifewine_amount,
		"Manapot":  Global.manapot_amount,
		"Opals" : Global.opals_amount ,
		"CommonMonsterDust": Global.common_monster_dust_amount,
		"GoblinScales": Global.goblin_scales_amount,
		"RevivementCrystals" : Global.crystals_amount,
		"SoulTokens": Global.soul_token_amount,
		"DashUnlocked" : Global.dash_unlocked ,
		"GlideUnlocked" : Global.glide_unlocked,
		"FireSawUnlocked": Global.firesaw_unlocked,
		"FireFairyUnlocked": Global.fire_fairy_unlocked,
		"ChestOpened": Global.opened_chests,
		"MaxItemStorage":  Global.max_item_storage, 
		
		"IsLoadingASave": Global.is_loading_a_save,
		"PlayerPosition": Global.player_position,
		# Equipped skills
		"PrimarySkill" : Global.player_skills["PrimarySkill"],
		"SecondarySkill": Global.player_skills["SecondarySkill"],
		"RangedSkill" :  Global.player_skills["RangedSkill"],
		# Unlocked skills
		"PrimarySkillUnlocked": Global.unlocked_skills["PrimarySkill"],
		"SecondarySkillUnlocked": Global.unlocked_skills["SecondarySkill"],
		"RangedSkillUnlocked": Global.unlocked_skills["RangedSkill"],
		# Levels
		"FireSawLevel": Global.skill_levels["FireSawLevel"],
		"FireFairyLevel": Global.skill_levels["FireFairyLevel"],
		"FireballLevel": Global.skill_levels["FireballLevel"],
		"Lighting" : Global.lighting,
		"Vsync" : Global.vsync,
		"EnemiesKilled": Global.enemies_killed ,
		"MaskedGoblinDefeated" : Global.masked_goblin_defeated,
		"ActivatedPortals": Global.activated_portals
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
func sync_playerCommonMonsterDust(player_common_monster_dust : int):
	player_common_monster_dust = Global.common_monster_dust_amount
func sync_playerGoblinScales(player_goblin_scales: int):
	player_goblin_scales = Global.goblin_scales_amount




