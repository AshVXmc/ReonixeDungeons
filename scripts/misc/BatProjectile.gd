class_name BatProjectile extends Area2D

var velocity = Vector2()
const GRAVITY = 20

func _ready():
	$AnimatedSprite.play("default")

func _physics_process(delta):
	velocity.y = GRAVITY
	translate(velocity)
