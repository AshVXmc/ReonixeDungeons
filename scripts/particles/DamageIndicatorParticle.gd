class_name DamageIndicator extends Node2D

var SPEED : int = 185
var friction : int = 20
var direction_shift : Vector2 = Vector2()
onready var damage_type : String
onready var damage : float

func _ready():
	match damage_type:
		"Physical":
			$AnimationPlayer.play("physical_particle")
		"Fire":
			$AnimationPlayer.play("fire_particle")
		"Ice": 
			$AnimationPlayer.play("ice_particle")
		"Earth":
			$AnimationPlayer.play("earth_particle")
	$Label.text = str(damage)
	direction_shift = Vector2(rand_range(-1,1), rand_range(-1,1))


func _process(delta):
	global_position += SPEED * direction_shift * delta
	SPEED = max(SPEED - friction * delta , 0)
