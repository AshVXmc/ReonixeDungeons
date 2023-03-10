class_name DamageIndicator extends Node2D

var SPEED : int = 200
var friction : int = 35
var direction_shift : Vector2 = Vector2()
onready var damage_type : String
onready var damage : float
onready var is_crit : bool 


func _ready():
	if is_crit:
		$CritLabel.visible = true
		$CritAnimationPlayer.play("CritHit")
		scale.x = 1.25
		scale.y = 1.25
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
