extends Node 

var can_open_pause_menu : bool = false
# GLOBALLY ACCESSED VARIABLES
var character_health_data : Dictionary = {
	"Player": 10, 
	"Glaciela": 10,
	"Agnette": 10
}

var max_hearts : float
var hearts : float
var max_mana : float = 18
var mana : float = max_mana
var character_2_max_hearts : float
var character2_hearts : float
var character2_max_mana = max_mana
var character2_mana = max_mana
var character_3_max_hearts : float 
var character3_hearts : float 
var character3_max_mana = max_mana
var character3_mana = max_mana


var elegance_rank : String 
var enemy_level_index : int = 1
var max_endurance : int = 100
var player_location_in_town 
#func _ready():
#	#CREATE SAVE FILE
#	var dir : Directory = Directory.new()
#	if !dir.dir_exists(SAVE_DIR):
#		dir.make_dir_recursive(SAVE_DIR)
# C tier has 50, B tier has 75, A tier has 125, S tier has 175, SS has 200 SSS has 250

const actions : Array = [
	"basic_attack", 
	"charged_attack", 
	"primary_skill", "secondary_skill",
	"dash", "perfect_dash"
]

# attack_power is the player's atk
var attack_power : int = 20
var glaciela_attack : int = 20
var player_skill_multipliers : Dictionary = {
	"BaseHearts": 2.5,
	"BasicAttack": 15.0,
	"BasicAttack2": 20.0,
	"BasicAttack3": 25.0,
	"BasicAttack4": 52.5,
	"ChargedAttack": 47.0,
	"ThrustAttack": 56.0,
	"ThrustChargedAttack": 85.0,
	"UpwardsChargedAttack": 28.0, # x 2
	"DownwardsChargedAttack": 56.0,
	"SpecialChargedAttack": 30.0 ,# x 4
	"SpecialChargedAttackFinalStrike": 140.0,
	"CircularFlurryAttack": 40.0, # x 3
	"PiercingProjectile": 95.0,
	"EntryAttack": 50.0, # x 3
	"CounterAttack": 42.0, # x 2
	"AirborneBasicAttack": 25.0,
	"AirborneBasicAttack2": 30.0,
	"AirborneBasicAttack3": 35.0,
	"AirborneBasicAttack4": 65.0,
	"SulphuricSigilSingleSlash": 40.0, # x 2
	"SlashFlurryEnergyCost": 200,
	"FireSaw": 35.0,
	"FireSawDuration": 8.0,
	"FireFairy": 22.0,
	"Fireball": 50.0,
	"FireballCD": 6.0,
	"FireballCharges": 3,
	"FireballMaxCharges": 3,
	"FireSawCost": 18,
	"FireFairyCost": 2,
	"FireballCost": 2,
	"FireSawCD": 30.0,
	"FireFairyCD": 10.0,
	"BasePhysRes": 0.0,
	"BaseMagicRes": 0.0,
	"BaseFireRes": 0.0,
	"BaseEarthRes": 0.0,
	"BaseIceRes": 0.0,
	"PhysDamageBonus": 0.0,
	"FireDamageBonus": 0.0,
	"IceDamageBonus": 0.0,
	"EarthDamageBonus": 0.0,
	"CritRate": 15.0,
	"CritDamage": 100.0,
	"Birthday": [21,11]
}

enum player_skins  {
	DEFAULT,
	CYBER_NINJA
}
var player_unlocked_skins = {
	"CyberNinja": false
}

var player_talents : Dictionary = {
	"TalentSlots": 5,
	"MaxTalentSlots": 5,
	"CycloneSlashes" : {
		"unlocked" : true,
		"enabled" : true,
		"opalscost": 100,
		"talentslotcost": 2
	},
	"SwiftThrust" : {
		"unlocked" : false,
		"enabled" : false,
		"opalscost": 100,
		"talentslotcost": 2
	},
	# Talent has not been implemented yet
	"BurningBreath" : {
		"unlocked" : true,
		"enabled" : true,
		"opalscost": 100,
		"talentslotcost": 3
	},
	# Talent has not been implemented yet
	"InfernalMark" : {
		"unlocked" : false,
		"enabled" : false,
		"opalscost": 100,
		"DamageIncrease" : 25,
		"talentslotcost": 2
	},
	"CreateSugarRoll": {
		"unlocked" : false,
		"enabled": false,
		"opalscost": 100,
		"cooldown": 35.0,
		"talentslotcost": 3
	},
	"ChaosMagic": {
		"unlocked" : true,
		"enabled": true,
		"opalscost": 100,
		# 45? 60? 100?
		"cooldown": 10,
		"talentslotcost": 3
	}
}


var glaciela_skill_multipliers : Dictionary = {
	"BasicAttack":  20.0,
	"BasicAttack2": 27.5,
	"BasicAttack3": 35.0,
	"BasicAttack4": 55.0,
	"ChargedAttack": 35.0,
	"SpecialAttack1_1": 45.0,
	"SpecialAttack1_2": 55.0,
	"SpecialAttack2_1": 25.0,
	"SpecialAttack2_2": 25.0,
	"SpecialAttack2_3": 50.0,
	"TundraStarsDMGBonus": 12.0,
	"TundraSigilFreezeStackBonus": 20,
	"TundraSigilManaBonus": 0.75,
	"TundraStarsIceDamageBonus": 12,
	"AirborneDuration": 2.5,
	"IceLance": 10.0, # prev: 70
	"MaxTundraStars": 3,
	"WinterQueen": 15.0,
	"WinterQueenCost": 1,
	"IceLanceCost": 0,
	"WinterQueenCD": 50.0,
	"IceLanceCD": 10.0,
	"BasePhysRes": 0.0,
	"BaseMagicRes": 0.0,
	"BaseFireRes": -50.0,
	"BaseEarthRes": 0.0,
	"BaseIceRes": 0.0,
	"CritRate": 25.0,
	"CritDamage": 75.0,
	"PhysDamageBonus": 0.0,
	"FireDamageBonus": 0.0,
	"IceDamageBonus": 0.0,
	"EarthDamageBonus": 0.0,
	"Birthday": [10,5]
}


var agnette_skill_multipliers = {
	
}

var enemy_skill_multipliers : Dictionary = {
	"GoblinSpearThrustAttack" : 100.0
}



var charged_attack_multiplier : float = 2
var base_damage_taken : int = 5
var healthpot_amount : int = 5
var lifewine_amount : int = 0
var manapot_amount : int = 0

var crystals_amount : int = 0
var opened_chests := []
var soul_token_amount : int = 0
const SAVE_DIR : String = "user://savedata/"

var max_item_storage : int = 5
var levelpath : String
var is_loading_a_save : bool
var player_position : Vector2
var savepath : String = SAVE_DIR + "savefile.dat"
var lighting : bool = false
var vsync : bool = false
var activated_portals : Array



var is_opening_an_UI : bool = false
var pity_4_star : int = 10
var pity_5_star : int = 60 # Soft pity at 50

# Resources
var opals_amount : int = 0
var drops_inventory : Dictionary = {
	"common_dust" : 0,
	"goblin_scales": 0,
	"bat_wings": 0,
	"sweet_herbs": 0
}

var tokens_amount : int = 0
var lesser_soul_catalyst : int= 0


# Skills that the player currently equips
var player_skills : Dictionary = {
	"PrimarySkill" : "FireSaw",
	"SecondarySkill" : "FireFairy",
	"RangedSkill" : ""
}

var glaciela_skills : Dictionary = {
	"PrimarySkill" : "WinterQueen",
	"SecondarySkill" : "IceLance",
	"RangedSkill" : ""
}




var current_character : String 
var equipped_characters : Array = ["Player", "Glaciela", "Agnette"]
var unlocked_characters : Array = ["Player", "Glaciela", ""]
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
	"PrimarySkill": ["FireSaw", "WinterQueen"], 
	"SecondarySkill": ["FireFairy", "IceLance"],
	"RangedSkill": ["Fireball"]
}

# List of unlocked skills
var unlocked_skills : Dictionary = {
	"PrimarySkill": ["FireSaw"],
	"SecondarySkill": ["FireFairy"],
	"RangedSkill": ["Fireball"]
}
var character_level_data : Dictionary = {
	# [current level, current xp, xp needed to level up]
	# for every level, the xp needed to level up is increased by 10.
	# e.g: 20 XP to get from level 2 to 3, 30XP to get from level 3 to level 4
	"Player": [1, 0, 10],
	"Glaciela": [1, 0, 10],
	"Agnette": [1, 0, 10]
}


var enemies_killed : int
# Boss Victories
var masked_goblin_defeated : bool

# Unsaved conditions
var godmode : bool = false

func assign_health_points():
	for e in Global.equipped_characters:
		if e != "":
			var index : int = Global.equipped_characters.find(e)
			match index:
				0:
					Global.max_hearts = Global.character_health_data[e]
					Global.hearts = Global.max_hearts
				1:
					Global.character_2_max_hearts = Global.character_health_data[e]
					Global.character2_hearts = Global.character_2_max_hearts
				1:
					Global.character_3_max_hearts = Global.character_health_data[e]
					Global.character3_hearts = Global.character_3_max_hearts
# Damage calc

# if enemy type counters character type, deal 150% dmg.
# if enemy type is same as character type or doesn't counter anything, deal 100% dmg.
# if character type counters enemy type, deal 50% dmg
func reset_player_data():
	Global.equipped_characters = ["Player", "Glaciela", "Agnette"]
	assign_health_points()
	Global.alive = [true, true, true]
	Global.mana = 0
	Global.character2_mana = 0
	Global.character3_mana = 0
	Global.healthpot_amount = 1
	Global.lifewine_amount = 0
	Global.manapot_amount = 0
	Global.opals_amount = 0
	Global.crystals_amount = 0
	Global.drops_inventory = {
		"common_dust" : 0,
		"goblin_scales": 0,
		"bat_wings": 0,
		"sweet_herbs": 0
	}
	Global.soul_token_amount = 0

	Global.is_loading_a_save = false
	Global.max_item_storage = 5
	Global.lighting = false
	Global.levelpath = ""
	Global.enemies_killed = 0
	Global.masked_goblin_defeated = false
	Global.player_skills = {
		"PrimarySkill": "FireSaw",
		"SecondarySkill": "FireFairy",
		"RangedSkill": "Fireball"
	}
	Global.character_level_data = {
		"Player": [1, 0, 20],
		"Glaciela": [1, 0, 20],
		"Agnette": [1, 0, 20]
	}
	Global.vsync = false
	Global.activated_portals.clear()

func delete_save_file():
	var dir : Directory = Directory.new()
	dir.open(SAVE_DIR)
	dir.remove("savefile.dat")
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
		
#		"MaxHealth": Global.max_hearts ,
#		"Health" : Global.hearts ,
#		"Char2MaxHealth": Global.character_2_max_hearts,
#		"Char2Health": Global.character2_hearts,
#		"Char3MaxHealth": Global.character_3_max_hearts,
#		"Char3Health": Global.character3_hearts,
		
		
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
		"CommonDust": Global.drops_inventory["common_dust"],
		"GoblinScales": Global.drops_inventory["goblin_scales"],
		"BatWings": Global.drops_inventory["bat_wings"],
		"SweetHerbs": Global.drops_inventory["sweet_herbs"],
		"RevivementCrystals" : Global.crystals_amount,
		"SoulTokens": Global.soul_token_amount,

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
		"CharacterLevelData": Global.character_level_data
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
#func sync_playerCommonMonsterDust(player_common_monster_dust : int):
#	player_common_monster_dust = Global.common_monster_dust_amount
#func sync_playerGoblinScales(player_goblin_scales: int):
#	player_goblin_scales = Global.goblin_scales_amount





