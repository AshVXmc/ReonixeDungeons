class_name HealIndicator extends Node2D

var SPEED : int = 185
var friction : int = 20
var direction_shift : Vector2 = Vector2()
onready var heal_amount : float

func _ready():
	$Label.text = "+" + str(heal_amount)
	direction_shift = Vector2(rand_range(-1,1), rand_range(-1,1))


func _process(delta):
	global_position += SPEED * direction_shift * delta
	SPEED = max(SPEED - friction * delta , 0)
