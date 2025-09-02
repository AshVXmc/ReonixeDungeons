class_name BaseEnemy extends KinematicBody2D

var max_HP_calc : int 
var level_calc : int
var max_HP : int
var level : int
var HP : int 
var atk_value : float 

var MAX_SPEED : int = 125
var SPEED : int = MAX_SPEED
var MAX_GRAVITY : int = 45
var GRAVITY : int = MAX_GRAVITY
const TYPE : String = "Enemy"

export (int) var phys_res : int = -33.3
export (int) var fire_res : int = -33.3
export (int) var earth_res : int = 0
export (int) var ice_res : int = 0
export (int) var global_res : int = 0

var elemental_type : String = "Physical"
var weaknesses : Array = ["Physical", "Fire"]

var enemy_name : String 

# optional?
export (String, "Physical", "Magical", "Fire", "Ice", "Earth") var Armor_Type = "Physical"
export (int) var Armor_Durability = 100 # amount of poise/hits/elemental stacks needed to break the shield
export (float, 1.0) var Armor_Strength = 0.9 # total damage reduction the shield gives (0 is none, 1 is 100% reduction)
var armor_strength_coefficient : int = 1 # default value so it doesn't throw an error

var debuff_damage_multiplier : float = 1

