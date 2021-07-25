extends KinematicBody2D

var velocity = Vector2()
var direction : int = 1
var is_dead : bool = false 
const TYPE : String = "Enemy"
const FLOOR = Vector2(0, -1)
const SPEED : int = 200
const GRAVITY : int = 45
var player = null

func _physics_process(delta):
#	velocity.x = SPEED * direction
	velocity.y += GRAVITY
	velocity = move_and_slide(velocity, FLOOR)



func _on_Left_body_entered(body):
	if body.get("TYPE") == "Player":
		velocity.x -= 350


func _on_Left_body_exited(body):
	player = null
	


func _on_Right_body_entered(body):
	if body.get("TYPE") == "Player":
		velocity.x += 350


func _on_Right_body_exited(body):
	player = null
