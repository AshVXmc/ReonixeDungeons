extends Node 

# GLOBALLY ACCESSED VARIABLES
var max_hearts : float = 3
var hearts : float = max_hearts
var character_2_max_hearts : float = 3
var character_3_max_hearts : float = 3
var elegance_rank : String 

func _ready():
	print(Time.get_date_dict_from_system())


# C tier has 50, B tier has 75, A tier has 125, S tier has 175, SS has 200 SSS has 250

const actions : Array = [
	"basic_attack", 
	"charged_attack", 
	"primary_skill", "secondary_skill",
	"dash", "perfect_dash"
]
var max_mana : float = 18
var mana : float = max_mana
var attack_power : int = 50
var player_skill_multipliers : Dictionary = {
	"BaseHearts": 2.5,
	"BasicAttack": 25.0,
	"BasicAttack2": 35.0,
	"BasicAttack3": 42.5,
	"BasicAttack4": 48.5,
	"ChargedAttack": 52.0,
	"ThrustChargedAttack": 69.5,
	"UpwardsorDownwardsChargedAttack": 30.0, # x 2
	"SpecialChargedAttack": 45.5, # x 4
	"SpecialChargedAttackFinalStrike": 135.0,
	"AirborneBasicAttack": 35.0,
	"AirborneBasicAttack2": 30.0,
	"AirborneBasicAttack3": 45.0,
	"AirborneBasicAttack4": 55.0,
	"SulphuricSigilSingleSlash": 40.0, # x 2
	"SlashFlurryEnergyCost": 150,
	"FireSaw": 35.0,
	"FireFairy": 22.0,
	"FireSawCost": 12,
	"FireFairyCost": 0,
	"FireSawCD": 20.0,
	"FireFairyCD": 8.0,
	"BasePhysRes": 0.0,
	"BaseMagicRes": 0.0,
	"BaseFireRes": 0.0,
	"BaseEarthRes": 0.0,
	"BaseIceRes": 0.0,
	"Birthday": [21,11]
}


var glaciela_attack : int = 50
var glaciela_skill_multipliers : Dictionary = {
	"BasicAttack":  30.0,
	"BasicAttack2": 35.0,
	"BasicAttack3": 45.0,
	"BasicAttack4": 50.0,
	"ChargedAttack": 45.0,
	"SpecialAttack1_1": 18.0,
	"SpecialAttack1_2": 22.0,
	"TundraSigilDMGBonus": 12.0,
	"TundraSigilFreezeStackBonus": 20,
	"TundraSigilManaBonus": 0.75,
	"AirborneDuration": 2.5,
	"IceLance": 65.0,
	"MaxTundraSigils": 3,
	"SecondarySkill1": 65.0,
	"SecondarySkill2": 75.0,
	"SecondarySkill3": 100.0,
	"BasePhysRes": 0.0,
	"BaseMagicRes": 0.0,
	"BaseFireRes": -50.0,
	"BaseEarthRes": 0.0,
	"BaseIceRes": 0.0,
	"Birthday": [10,5]
}

var character2_hearts : float= character_2_max_hearts
var character2_max_mana = max_mana
var character2_mana = max_mana
var character3_hearts : float = character_3_max_hearts
var character3_max_mana = max_mana
var character3_mana = max_mana



var charged_attack_multiplier : float = 2
var base_damage_taken : int = 5
var healthpot_amount : int = 0
var lifewine_amount : int = 0
var manapot_amount : int = 0

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
var is_opening_an_UI : bool = false
var pity_4_star : int = 10
var pity_5_star : int = 60 # Soft pity at 50

# Resources
var opals_amount : int = 0
var common_monster_dust_amount : int = 0
var goblin_scales_amount : int = 0
var tokens_amount : int = 0
var lesser_soul_catalyst : int= 0


# Skills that the player currently equips
var player_skills : Dictionary = {
	"PrimarySkill" : "",
	"SecondarySkill" : "",
	"RangedSkill" : ""
}






var current_character : String 
var equipped_characters : Array = ["Glaciela", "Player", ""]
var unlocked_characters : Array = ["Player", "Glaciela", "Domiguine"]
var alive : Array = [true, true, true]

# The level of skills. Higher levels = more damage and utility etc.


var damage_bonus : Dictionary = {
	"physical_dmg_bonus_%": 0,
	"fire_dmg_bonus_%": 0,
	"ice_dmg_bonus_%": 0,
	"earth_dmg_bonus_%": 0
}

# List of skills (Unlocked and locked)
var list_of_skills : Dictionary = {
	"PrimarySkill": ["FireSaw", "IceLance"], 
	"SecondarySkill": ["FireFairy"],
	"RangedSkill": ["Fireball"]
}

# List of unlocked skills
var unlocked_skills : Dictionary = {
	"PrimarySkill": ["FireSaw"],
	"SecondarySkill": ["FireFairy"],
	"RangedSkill": ["Fireball"]
}



var enemies_killed : int
# Boss Victories
var masked_goblin_defeated : bool

# Unsaved conditions
var godmode : bool = false

# Damage calc
# if enemy type counters character type, deal 150% dmg.
# if enemy type is same as character type or doesn't counter anything, deal 100% dmg.
# if character type counters enemy type, deal 50% dmg
func reset_player_data():
	Global.hearts = Global.max_hearts
	Global.character2_hearts = Global.character_2_max_hearts
	Global.character3_hearts = Global.character_3_max_hearts
	Global.alive = [true, true, true]
	Global.mana = 0
	Global.character2_mana = 0
	Global.character3_mana = 0
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
		"Char2MaxHealth": Global.character_2_max_hearts,
		"Char2Health": Global.character2_hearts,
		"Char3MaxHealth": Global.character_3_max_hearts,
		"Char3Health": Global.character3_hearts,
		"MaxMana" : Global.max_mana ,
		"Mana" : Global.mana ,
		"Char2MaxMana": Global.character2_max_mana,
		"Char2Mana": Global.character2_mana,
		"Char3MaxMana": Global.character3_max_mana,
		"Char3Mana": Global.character3_mana,
		"4StarPity": Global.pity_4_star,
		"5StarPity": Global.pity_5_star,
		"AttackPower": Global.attack_power,
		"GlacielaAttackPower": Global.glaciela_attack,
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
		
		"EquippedCharacters": Global.equipped_characters,
		"CurrentCharacter": Global.current_character,
		"UnlockedCharacters": Global.unlocked_characters,
		"IsLoadingASave": Global.is_loading_a_save,
		"PlayerPosition": Global.player_position,
		# Equipped skills
		# Levels
		"PlayerSkillMultipliers": Global.player_skill_multipliers,
		"GlacielaSkillMultipliers": Global.glaciela_skill_multipliers,
		
		"PhysicalDMGBonus%": Global.damage_bonus["physical_dmg_bonus_%"],
		"FireDMGBonus%": Global.damage_bonus["fire_dmg_bonus_%"],
		"IceDMGBonus%": Global.damage_bonus["ice_dmg_bonus_%"],
		"EarthDMGBonus%": Global.damage_bonus["earth_dmg_bonus_%"],
		"Lighting" : Global.lighting,
		"Vsync" : Global.vsync,
		"EnemiesKilled": Global.enemies_killed ,
		"MaskedGoblinDefeated" : Global.masked_goblin_defeated,
		"ActivatedPortals": Global.activated_portals,
		
	}

	var savefile : File = File.new()
	var error = savefile.open(savepath, File.WRITE)
	if error == OK:
		savefile.store_var(load_data)
		savefile.close()

func parse_action(action_type):
	if actions.has(action_type) and action_type != null:
		return action_type
		print("=>" + action_type)



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





