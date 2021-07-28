extends Node 

# GLOBALLY ACCESSED VARIABLES
var max_hearts : float = 4
var hearts : float = max_hearts

func _ready():
	print("Global variables!")
	
func sync_hearts(player_hearts : float):
	player_hearts = Global.hearts
