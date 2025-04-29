extends Node 

var can_open_pause_menu : bool = false
# GLOBALLY ACCESSED VARIABLES
var character_health_data : Dictionary = {
	"Player": 10, 
	"Glaciela": 10,
	"Agnette": 10
}
var character_defense_data : Dictionary = {
	"Player": 1.6, 
	"Glaciela": 2.6,
	"Agnette": 0.85
}




var max_hearts : float
var hearts : float
var max_mana : float = 20
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

const TEMPUS_TARDUS_CD : int = 20
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
var equipped_character_skins_data : Dictionary = {
	"Player": "DEFAULT_SKIN",
	"Glaciela": "DEFAULT_SKIN",
	"Agnette": "DEFAULT_SKIN"
}
var equipped_character_skins : Dictionary = {
	"Player": "DEFAULT_SKIN",
	"Glaciela": "DEFAULT_SKIN",
	"Agnette": "DEFAULT_SKIN"
}

# attack_power is the player's atk
var attack_power : int = 14
var glaciela_attack : int = 14
var agnette_attack : int = 14
var player_skill_multipliers : Dictionary = {
	"BaseHearts": 2.5,
	"BasicAttack": 25.0,
	"BasicAttack2": 30.0,
	"BasicAttack3": 35.0,
	"BasicAttack4": 60.0,
	"ChargedAttack": 75.0,
	"ThrustAttack": 80.0,
	"ThrustChargedAttack": 75.0,
	"UpwardsChargedAttack": 28.0, # x 2
	"DownwardsChargedAttack": 56.0,
	"SpecialChargedAttack": 50.0 ,# x 4
	"SpecialChargedAttackFinalStrike": 180.0,
	"CircularFlurryAttack": 40.0, # x 3
	"PiercingProjectile": 95.0,
	"EntryAttack": 50.0, 
	"CounterThrustAttack": 45.0,
	"CounterAttack": 32.0, # x 2
	"AirborneBasicAttack": 30.0,
	"AirborneBasicAttack2": 38.0,
	"AirborneBasicAttack3": 48.0,
	"AirborneBasicAttack4": 70.0,
	"SulphuricSigilSingleSlash": 40.0, # x 2
	"SlashFlurryEnergyCost": 200,
	"FireSaw": 80.0,
	"FireSawDuration": 8.0,
	"FireFairy": 32.0,
	"FireFairyDetonation": 65.0,
	"FireFairyDuration": 7.5,
	"Fireball": 48.0,
	"FireballCD": 6,
	"FireballCharges": 3,
	"FireballMaxCharges": 3,
	"FireballBurnGauge": 340,
	"FireSawCost": 20,
	"FireFairyCost": 3,
	"FireFairyJointAttackPoints": 2,
	"FireballCost": 2,
	"FireSawCD": 30.0,
	"FireFairyCD": 12.0,
	"FireCharmDuration": 6.5,
	"FireCharmCD": 8.5,
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

# player talents are passive skills
# valid categories: Primary Skill, Secondary Skill, Tertiary Skill, Moveset, Perk skill, Passive
var player_talents : Dictionary = {
	"TalentSlots": 0,
	"MaxTalentSlots": 5,
	
	"CycloneSlashes" : {
		"unlocked" : false,
		"enabled" : false,
		"opalscost": 100,
		"talentslotcost": 1,
		"category": "Moveset",
		"name": "Cyclone Slashes",
		"description": "Doing a charged attack after Basic Attack SEQ 2 unleashes a flurry of windblades to deal multiple instances of Physical DMG."
	},
	"SwiftThrust" : {
		"unlocked" : false,
		"enabled" : false,
		"opalscost": 100,
		"talentslotcost": 1,
		"category": "Moveset",
		"name": "Swift Thrust",
		"description": "Airborne charged attacks can now be chained up to 2 times."
	},
	# Talent has not been implemented yet
	"BurningBreath" : {
		"unlocked" : false,
		"enabled" : false,
		"opalscost": 100,
		"talentslotcost": 2,
		"attackpercentage": 70.0,
		"cooldown": 10,
		"category": "Passive",
		"name": "Burning Breath",
		"description": "When you take damage, deal [color=#fd9628]Fire[/color] damage and apply [color=#fd9628]Burning[/color] to enemies in front of you."
	},
	"InfernalMark" : {
		"unlocked" : false,
		"enabled" : false,
		"opalscost": 100,
		"DamageIncrease" : 16,
		"talentslotcost": 3,
		"category": "SecondarySkill",
		"name": "Infernal Mark",
		"description": "Enemies marked with Sulphuric Sigil take more damage."
	},
	"SoulSiphon": {
		"unlocked" : false,
		"enabled" : false,
		"opalscost": 100,
		"dropchance": 25,
		"healthgranted" : 25,
		"talentslotcost": 3,
		"category": "Passive",
		"name": "Soul Siphon",
		"description": "Upon death, enemies have a chance to drop a [color=#540d17]Soul Orb[/color]. The Player and him alone can pick up these orbs to restore health."
	},
	# allows pierce fireball
	"PiercingFervor": {
		"unlocked" : false,
		"enabled" : false,
		"opalscost": 100,
		"damagepenalty": 25.0,
		"talentslotcost": 3,
		"category": "TertiarySkill",
		"name": "Piercing Fervor",
		"description": "Projectiles from the Fireball skill pierce enemies, but deal less damage."
	},
	"MeteorShower": {
		"unlocked" : false,
		"enabled" : false,
		"opalscost": 100,
		"damage": 82.0,
		"amount": 4,
		"talentslotcost": 4,
		"category": "PrimarySkill",
		"name": "Meteor Shower",
		"description": "Casting Firesaw calls down blazing meteors, dealing significant [color=#fd9628]Fire[/color] damage."
	},
	
	
	
	"BadBlood":{
		# dropping to critical health grants temporary attack boost and speed boost
		# cooldown
		"unlocked" : false,
		"enabled" : false,
		"opalscost": 100,
		"cooldown": 20,
		"name": "TBA",
		"description": "TBA"
	}
}


var player_skills : Dictionary = {
	"PrimarySkill" : "FireSaw",
	"SecondarySkill" : "FireFairy",
	"TertiarySkill" : "Fireball",
	"PerkSkill": "CreateSugarRoll"
}


var glaciela_talents : Dictionary = {
	"TalentSlots": 0,
	"MaxTalentSlots": 5,
	"DanceOfRime" : {
		"unlocked" : false,
		"enabled" : false,
		"opalscost": 100,
		"talentslotcost": 1,
		"name": "Dance of Rime",
		"description": "Doing the following attack sequence ([color=#ffd703]ATK[/color], [color=#ffd703]ATK[/color], [color=#ffd703]ATK[/color], pause until a [color=yellow]yellow star[/color] appears and press [color=#ffd703]ATK[/color]) unleashes a spear dance that deals multiple instances of [color=#7df0ff]Ice[/color] DMG and knocks enemies back."
	},
	# a stack of tundra sigil is consumed every time u take damage to reduce it
	"WardOfBoreas": {
		"unlocked" : false,
		"enabled" : false,
		"opalscost": 100,
		"talentslotcost": 1,
		"damagemitigation": 35.0,
		"name": "Ward of Boreas",
		"description": "When you take damage, a stack of Tundra Star is consumed to reduce your damage taken."
	},
	# casting ult restores tundra stacks to full and fully restores cone of cold meter
	"GiftOfTheStorm": {
		"unlocked" : false,
		"enabled" : false,
		"opalscost": 100,
		"talentslotcost": 3,
		"name": "Gift of the Storm",
		"description": "Casting Winter Queen grants you the maximum amount of Tundra Stars and fully restores Cone Of Cold's meter."
	}
#	# like bap's immortality field, triggered during ult
#	"SanctuaryOfSolstice": {
#		"unlocked" : false,
#		"enabled" : false,
#		"opalscost": 100,
#		"talentslotcost": 2,
#		"healththreshold": 0.1
#	}
}

var glaciela_skills : Dictionary = {
	"PrimarySkill" : "WinterQueen",
	"SecondarySkill" : "IceLance",
	"TertiarySkill" : "ConeOfCold",
	"PerkSkill": ""
}


# player perks are activated fourth skills
var player_perks : Dictionary = {
	"CreateSugarRoll": {
		"unlocked" : true,
		"enabled": false,
		"health": 0.4,
		"opalscost": 100,
		"cooldown": 35.0,
#		"talentslotcost": 3
	},
	"ChaosMagic": {
		"unlocked" : true,
		"enabled": false,
		"opalscost": 100,
		# 45? 60? 100?
		"cooldown": 25.0,
		# 25% chance
		"triggerchance": 25,
#		"talentslotcost": 3
	}
}

var glaciela_skill_multipliers : Dictionary = {
	"BasicAttack":  36.0,
	"BasicAttack2": 48.0,
	"BasicAttack3": 55.0,
	"BasicAttack4": 69.0,
	"ChargedAttack": 40.0,
	"SpecialAttack1_1": 35.0,
	"SpecialAttack1_2": 45.0,
	"SpecialAttack2_1": 16.0,
	"SpecialAttack2_2": 22.0,
	"SpecialAttack2_3": 40.0,
	"IceLanceDamageBonusPerTundraSigil": 85,
	"TundraSigilFreezeStackBonus": 30,
	"TundraSigilManaBonus": 0.75,
	"TundraStarsIceDamageBonus": 48,
	"AirborneDuration": 2.5,
	"IceLance": 60.0,
	"IceLanceFreezeGauge": 300.0,
	"MaxTundraStars": 3,
	"WinterQueen": 11.0,
	"WinterQueenCost": 14,
	"WinterQueenCD": 28.0,
	"WinterQueenDuration": 7.2,
	"WinterQueenFreezeGauge": 340,
	"IceLanceCost": 3,
	
	"IceLanceCD": 11.0,
	
	
	# for some reason it won't register any values below 100.
	# so this is a fix. if it works, it works
	"ConeOfCold": 100 * 0.25,
	"ConeOfColdFreezeGauge": 145,
	"ConeOfColdCD": 4,
	"ConeOfColdResourceConsumption": 90, # per tick.
	"ConeOfColdRegenRate": 1.3,
	"ConeOfColdMovementSpeedPenalty": 65.0,
	# minimum amount of mana to be able to channel it.
	"ConeOfColdCost": 0,
	
	"SnowBoulder": 78.0,
	"SnowBoulderCD": 30,
	"BasePhysRes": 0.0,
	"BaseMagicRes": 0.0,
	"BaseFireRes": -50.0,
	"BaseEarthRes": 0.0,
	"BaseIceRes": 0.0,
	"CritRate": 10.0,
	"CritDamage": 65.0,
	"PhysDamageBonus": 0.0,
	"FireDamageBonus": 0.0,
	"IceDamageBonus": 0.0,
	"EarthDamageBonus": 0.0,
	"Birthday": [10,5]
}


var agnette_skill_multipliers = {
	"Arrow1": 19.0,
	"Arrow2": 24.0,
	"Arrow3": 30.0,
	"Arrow4": 42.0,
	"ChargedAttackMovementSpeedPenalty": 80.0,
	"RainOfArrows": 40.0,
	
	"BearFormCost": 16,
	"BearFormCD": 30,
	"BearFormDuration": 15,
	# health taken from agnette's max HP.
	"BearFormHealth": 110.0,
	"BearFormMovementSpeedPenalty": 26.0,
	"BearFormAttack1": 140.0,
	"BearFormShockwave": 20.0,
	"BearFormShockwaveMaxHits": 5,
	
	"RavenFormCost": 0,
	"RavenFormCD": 16,
	"RavenFormDuration": 8.5,
	"RavenFormHealth": 65.0,
	"RavenFormPeckAttack": 58.0,
	"RavenFormBombardmentAttack": 64.0,
	"SpikeGrowth": 15.0,
	"SpikeGrowthCD": 10,
	"SpikeGrowthCharges": 2,
	"SpikeGrowthDuration": 5,
	"SpikeGrowthMaxCharges": 2,
	"CritRate": 10.0,
	"CritDamage": 65.0,
}

var agnette_talents : Dictionary = {
	"TalentSlots": 0,
	"MaxTalentSlots": 5,
	"Stoneskin" : {
		"unlocked" : false,
		"enabled": false,
		"opalscost": 100,
		"talentslotcost": 1,
		"damagereduction": 16.0,
		"name": "Stoneskin",
		"description": "While charging your bow, you take less damage."
	},
	"VolleyShot" : {
		"unlocked" : false,
		"enabled": false,
		"opalscost": 100,
		"talentslotcost": 2,
		"cooldown": 10.0,
		"arrowdamagepercentage": 40.0,
		"name": "Volley Shot",
		"description": "Your bow's Charged Attack fires 2 extra arrows that deal reduced damage. The Charge meter must be at least 70% full."
	},
	# raven dash to unleash lightning
	"StormyTempest" : {
		"unlocked" : false,
		"enabled": false,
		"damage": 35.0,
		"cooldown": 4.0,
		"opalscost": 100,
		"talentslotcost": 3,
		"name": "Stormy Tempest",
		"description": "Dashing in [color=#1f1f1f]Raven form[/color] calls down lightning strikes that deal [color=#deb600]Earth[/color] damage.  "
	},
	# bear can dash, releasing earthquakes 
#	"RoaringTrample" : {
#		"unlocked" : true,
#		"enabled": true,
#		"opalscost": 100,
#		"talentslotcost": 3,
#	}
}

var agnette_skills : Dictionary = {
	"PrimarySkill" : "BearForm",
	"SecondarySkill" : "RavenForm",
	"TertiarySkill" : "SpikeGrowth",
	"PerkSkill": "SnowBoulder"
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




var current_character : String 
var equipped_characters : Array = ["Player", "Glaciela", "Agnette"]
var character_list : Array = ["Player", "Glaciela", "Agnette"]
var unlocked_characters : Array = ["Player", "Glaciela", "Agnette"]
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
	# [current level, number of currency needed to level up.
	# for now, the currency is opals. May add other later
	"Player": [1, 0, 20],
	"Glaciela": [1, 0, 20],
	"Agnette": [1, 0, 20]
}
var player_talents_data : Dictionary = player_talents.duplicate()
var player_perks_data : Dictionary = player_perks.duplicate()
var glaciela_talents_data : Dictionary = glaciela_talents.duplicate()
# variables ending without _data contain the information that is saved on the save file.
# variables ending  with _data contain the default info 


var enemies_killed : int
# Boss Victories
var masked_goblin_defeated : bool

# Beastiary unlock
var enemies_encountered : Dictionary = {
	"Slime": false,
	"FireSlime": false,
	"Bat": false,
	"Spider": false,
	"ElderSpider": false,
	"Goblin": false,
	"BowGoblin": false,
	"ShamanGoblin": false,
	"WitchGoblin": false
}
var enemies_encountered_data : Dictionary = enemies_encountered

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
				2:
					Global.character_3_max_hearts = Global.character_health_data[e]
					Global.character3_hearts = Global.character_3_max_hearts

func assign_mana_points():
	for e in Global.equipped_characters:
		if e != "":
			var index : int = Global.equipped_characters.find(e)
			match index:
				0:
					Global.mana = 0
				1:
					Global.character2_mana = 0
				2:
					Global.character3_mana = 0
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

	Global.player_talents = Global.player_talents_data.duplicate()
	Global.player_perks = Global.player_perks_data.duplicate()
	Global.glaciela_talents = Global.glaciela_talents_data.duplicate()
	
	Global.equipped_character_skins = Global.equipped_character_skins_data.duplicate()
	Global.enemies_encountered = Global.enemies_encountered_data.duplicate()
	Global.soul_token_amount = 0

	Global.is_loading_a_save = false
	Global.max_item_storage = 5
	Global.lighting = true
	Global.levelpath = ""
	Global.enemies_killed = 0
	Global.masked_goblin_defeated = false
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
		"CharacterHealthData": Global.character_health_data,
		"CharacterDefenseData": Global.character_defense_data,
		"EnemiesEncounteredData": Global.enemies_encountered_data,
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
		"EquippedSkins": Global.equipped_character_skins,
		# Equipped skills
		# Levels
		"PlayerSkillMultipliers": Global.player_skill_multipliers,
		"GlacielaSkillMultipliers": Global.glaciela_skill_multipliers,
		"PhysicalDMGBonus%": Global.damage_bonus["physical_dmg_bonus_%"],
		"FireDMGBonus%": Global.damage_bonus["fire_dmg_bonus_%"],
		"IceDMGBonus%": Global.damage_bonus["ice_dmg_bonus_%"],
		"EarthDMGBonus%": Global.damage_bonus["earth_dmg_bonus_%"],\
		
		"PlayerTalents": Global.player_talents.duplicate(),
		"GlacielaTalents": Global.glaciela_talents.duplicate(),
		
		"PlayerPerks": Global.player_perks,
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





