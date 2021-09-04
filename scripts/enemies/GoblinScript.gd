extends KinematicBody2D

export var HP : int = 2
var velocity = Vector2()
var direction : int = 1
var is_dead : bool = false 
const TYPE : String = "Enemy"
const FLOOR = Vector2(0, -1)
const SPEED : int = 350
const GRAVITY : int = 45
var player = null

const LOOT = preload("res://scenes/items/HealthPot.tscn")
onready var AREA_LEFT : Area2D = $Left
onready var AREA_RIGHT : Area2D = $Right
onready var PLAYER = get_parent().get_node("Player").get_node("Area2D")

func _physics_process(delta):
	velocity.y += GRAVITY
	velocity = move_and_slide(velocity, FLOOR)
	$Sprite.play("Idle") if velocity.x == 0 else $Sprite.play("Attacking")
	
	if AREA_LEFT.overlaps_area(PLAYER):
		$Sprite.flip_h = false
		velocity.x = -SPEED

func _on_Area2D_area_entered(area):
	if area.is_in_group("Sword") or area.is_in_group("Fireball") and HP > 0:
		HP -= 1
		set_modulate(Color(2,0.5,0.3,1))
		$HurtTimer.start()
		if HP <= 0:
			var loot = LOOT.instance()
			var lootrng : RandomNumberGenerator = RandomNumberGenerator.new()
			lootrng.randomize()
			var randomint = lootrng.randi_range(1,3)
			if randomint == 1:
				get_parent().add_child(loot)
				loot.position = $Position2D.global_position
			queue_free()

#func _on_Left_body_entered(body):
#	$Sprite.flip_h = false
#	if body.get("TYPE") == "Player":
#		velocity.x = -SPEED
#func _on_Right_body_entered(body):
#	$Sprite.flip_h = true
#	if body.get("TYPE") == "Player":
#		velocity.x = SPEED
#func _on_Left_body_exited(body):
#	if body.get("TYPE") == "Player":
#		$AttackingTimer.start()
#
#
#func _on_Right_body_exited(body):
#	if body.get("TYPE") == "Player":
#		$AttackingTimer.start()

func _on_HurtTimer_timeout():
	set_modulate(Color(1,1,1,1))

func _on_AttackingTimer_timeout():
	velocity.x = 0
	player = null

	
