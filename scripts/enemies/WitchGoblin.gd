class_name WitchGoblin extends KinematicBody2D

const FAMILIAR = preload("res://scenes/enemies/Familiar.tscn")
const GRAVITY : int = 45
const FLOOR = Vector2(0, -1)
var initial_pos : int = -7
var velocity = Vector2()
onready var PLAYER = get_parent().get_node("Player").get_node("Area2D")
var player_inside : bool = false

func _physics_process(delta):
	velocity.y += GRAVITY
	velocity = move_and_slide(velocity, FLOOR)
	if !$AnimatedSprite.flip_h:
		$SummoningPos.position.x = initial_pos
	elif $AnimatedSprite.flip_h:
		$SummoningPos.position.x = initial_pos * -1
		
	if $Left.overlaps_area(PLAYER):
		player_inside = true
		$AnimatedSprite.play("summoning")
		$AnimatedSprite.flip_h = false
	elif $Right.overlaps_area(PLAYER):
		player_inside = true
		$AnimatedSprite.play("summoning")
		$AnimatedSprite.flip_h = true

	if !player_inside:
		$SummoningTimer.stop()
	if !$Left.overlaps_area(PLAYER) or !$Right.overlaps_area(PLAYER):
		player_inside = false
#		$AnimatedSprite.play("default")
	
func summon_familiars():
	var familiar : Familiar = FAMILIAR.instance()
	get_parent().add_child(familiar)
	familiar.position = $SummoningPos.global_position

func _on_Left_area_entered(area):
		$SummoningTimer.start()

func _on_Right_area_entered(area):
		$SummoningTimer.start()


func _on_SummoningTimer_timeout():
	summon_familiars()
	if player_inside:
		$SummoningTimer.start()
	else:
		$SummoningTimer.stop()


#func _on_Left_area_exited(area):
#	$SummoningTimer.stop()
#
#
#func _on_Right_area_exited(area):
#	$SummoningTimer.stop()
