class_name WitchGoblin extends KinematicBody2D

export var HP : int = 3
const LOOT = preload("res://scenes/items/LootBag.tscn")
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


func _on_Area2D_area_entered(area):
	if area.is_in_group("Sword") or area.is_in_group("Fireball") and HP > 0:
		HP -= 1
		parse_damage()
	elif area.is_in_group("Sword2"):
		HP -= 3
		parse_damage()
func parse_damage():
	velocity.x = 0
	set_modulate(Color(2,0.5,0.3,1))
	if $HurtTimer.is_stopped():
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
		Global.enemies_killed += 1


func _on_HurtTimer_timeout():
	set_modulate(Color(1,1,1,1))
