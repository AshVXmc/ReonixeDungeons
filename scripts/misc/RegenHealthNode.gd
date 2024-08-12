class_name RegenHealthNode extends Node2D

var tick_amount : int = 4
var tick_duration : int = 1
var heal_per_tick_amount : float = 1
var character_name : String 
signal heal_player(amount)
signal heal_glaciela(amount)
signal heal_agnette(amount)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():

	$RegenTimer.wait_time = tick_duration
	connect("heal_player", get_parent(), "heal")
	connect("heal_glaciela", get_parent().get_node("CharacterManager/Glaciela"), "heal")
	connect("heal_agnette", get_parent().get_node("CharacterManager/Agnette"), "heal")
	$RegenTimer.start()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _on_RegenTimer_timeout():
	if tick_amount > 0:
#		emit_signal("heal_player", 1, false, false)
		match character_name:
			"Player":
				emit_signal("heal_player", character_name, heal_per_tick_amount, false,false)
				print("regen module")
#				print("heal")
			"Glaciela":
				emit_signal("heal_glaciela", character_name, heal_per_tick_amount, false,false)
			"Agnette":
				emit_signal("heal_agnette", character_name, heal_per_tick_amount, false, false)
		tick_amount -= 1
	else:
		call_deferred('free')
