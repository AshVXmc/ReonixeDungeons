class_name MeteorShower extends Node2D

var velocity = Vector2()
var SPEED = 650

func _ready():
	pass
	
func _physics_process(delta):
	velocity.y = SPEED * delta
	translate(velocity)
