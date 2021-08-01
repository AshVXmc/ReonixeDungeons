extends Node 

# GLOBALLY ACCESSED VARIABLES
var max_hearts : float = 4
var hearts : float = max_hearts
var max_mana : int = 6
var mana : int = max_mana
var healthpot_amount : int = 0

func reset_player_data():
	Global.hearts = 4
	Global.mana = 6
	Global.healthpot_amount = 0
	
func sync_hearts(player_hearts : float):
	player_hearts = Global.hearts
func sync_mana(player_mana : int):
	player_mana = Global.mana
func sync_playerHealthpots(player_healthpot : int):
	player_healthpot = Global.healthpot_amount
	
	
