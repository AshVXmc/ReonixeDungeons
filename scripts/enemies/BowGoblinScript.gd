class_name BowGoblin extends KinematicBody2D

export var HP : int = 4
export var flipped : bool = false
var velocity = Vector2()
var direction : int = 1
var is_dead : bool = false 
const TYPE : String = "Enemy"
const FLOOR = Vector2(0, -1)
const SPEED : int = 320
const GRAVITY : int = 45

const LOOT = preload("res://scenes/items/LootBag.tscn")
const ARROW = preload("res://scenes/enemies/bosses/Arrow.tscn")
onready var AREA_LEFT : Area2D = $Left
onready var AREA_RIGHT : Area2D = $Right
onready var PLAYER = get_parent().get_node("Player").get_node("Area2D")

func _physics_process(delta):
	# Movement and physics
	if flipped:
		$Sprite.flip_h = true
	velocity.y += GRAVITY
	velocity = move_and_slide(velocity, FLOOR)

	if AREA_LEFT.overlaps_area(PLAYER):
		$Sprite.flip_h = false
		if $ShootingTimer.is_stopped():
			$ShootingTimer.start()
	if AREA_RIGHT.overlaps_area(PLAYER):
		$Sprite.flip_h = true
		if $ShootingTimer.is_stopped():
			$ShootingTimer.start()
	
	

func shoot_arrow():
	$AnimationPlayer.play("Shoot")
	yield(get_tree().create_timer(0.4), "timeout")
	var arrow = ARROW.instance()
	get_parent().add_child(arrow)
	if $Sprite.flip_h:
		arrow.position = $RightPos.global_position
	else:
		arrow.flip_arrow_direction(-1)

		arrow.position = $LeftPos.global_position
	if AREA_LEFT.overlaps_area(PLAYER) or AREA_RIGHT.overlaps_area(PLAYER):
		$ShootingTimer.start()
	elif $VulnerableArea.overlaps_area(PLAYER):
		$ShootingTimer.stop()
	
func _on_Area2D_area_entered(area):
	if area.is_in_group("Sword") or area.is_in_group("Fireball") and HP > 0:
		HP -= 1
		parse_damage()
		$ShootingTimer.stop()
	elif area.is_in_group("Sword2"):
		HP -= 3
		parse_damage()
		$ShootingTimer.stop()

func _on_ShootingTimer_timeout():
	shoot_arrow()


func _on_Left_area_exited(area):
	$ShootingTimer.stop()
	$AnimationPlayer.play("Idle")

func _on_Right_area_exited(area):
	$ShootingTimer.stop()
	$AnimationPlayer.play("Idle")
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

func _on_AttackingTimer_timeout():
	velocity.x = 0




func _on_VulnerableArea_area_exited(area):
	if $ShootingTimer.is_stopped():
		$ShootingTimer.start()
