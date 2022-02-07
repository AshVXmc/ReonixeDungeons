class_name MaskedGoblin extends KinematicBody2D

const max_HP : int = 20
export var HP : int = 20
export var flipped : bool = false
var velocity = Vector2()
var direction : int = 1
const FLOOR = Vector2(0, -1)
var SPEED : int = 375
const GRAVITY : int = 45
const SHURIKEN : PackedScene = preload("res://scenes/enemies/bosses/Shuriken.tscn")
var is_staggered : bool = false
var is_knocked_back :bool = false
var repulsion = Vector2()
onready var PLAYER = get_parent().get_node("Player").get_node("Area2D")
onready var hb_full = preload("res://assets/UI/healthbar_full.png")
onready var hb_half = preload("res://assets/UI/healthbar_half.png")
onready var hb_critical = preload("res://assets/UI/healthbar_critical.png")
onready var telepos 

func _ready():
	$HealthBar.texture_progress = hb_full
	$ShootTimer.start()

func _physics_process(delta):
	# Health bar stuff
	update_healthbar_value()
	# Main movement code
	if flipped:
		$AnimatedSprite.flip_h = true
	velocity.y += GRAVITY
	$AnimatedSprite.play("default")
	if !is_staggered:
		velocity = move_and_slide(velocity, FLOOR)
		if $Left.overlaps_area(PLAYER):
			$AnimatedSprite.flip_h = false
			if !$AnimatedSprite.flip_h and !is_knocked_back:
				yield(get_tree().create_timer(0.4),"timeout")
				velocity.x = -SPEED
			if velocity.x == 0:
				is_knocked_back = true
				velocity.x = SPEED * 2
		if $Right.overlaps_area(PLAYER):
			$AnimatedSprite.flip_h = true
			if $AnimatedSprite.flip_h and !is_knocked_back:
				yield(get_tree().create_timer(0.4),"timeout")
				velocity.x = SPEED
			if velocity.x == 0:
				velocity.x = -SPEED * 2
	if is_staggered or is_staggered:
		velocity.x = 0

func update_healthbar_value():
	$HealthBar.texture_progress = hb_full
	if $HealthBar.value < $HealthBar.max_value * 0.75:
		$HealthBar.texture_progress = hb_half
	if $HealthBar.value < $HealthBar.max_value * 0.4:
		$HealthBar.texture_progress = hb_critical

func _on_Area2D_area_entered(area):
	if area.is_in_group("Sword") or area.is_in_group("Fireball") and HP > 0 and !is_knocked_back:
		HP -= 1
		$HealthBar.value -= 1
		is_staggered = true
		velocity.x = 0
		$HurtTimer.start()
		if HP <= 0:
			queue_free()
	if area.is_in_group("Player") and !is_knocked_back:
		is_staggered = true
		yield(get_tree().create_timer(1), "timeout")
		is_staggered = false

	
func _on_HurtTimer_timeout():
	is_staggered = false

func _on_AttackingTimer_timeout():
	velocity.x = 0


# SIGN TIP:
# The player can attack shurikens to gain mana
func _on_ShootTimer_timeout():
	ranged_attack()

func leap():
	velocity.y = -1500
	yield(get_tree().create_timer(0.4), "timeout")
	velocity.y = 0
	
func ranged_attack():
	is_staggered = true
	velocity.x = 0
	# shuriken load
	var sh1 : Shuriken = SHURIKEN.instance()
	var sh2 : Shuriken = SHURIKEN.instance()
	var sh3 : Shuriken = SHURIKEN.instance()
	var sh4 : Shuriken = SHURIKEN.instance()
	var sh5 : Shuriken = SHURIKEN.instance()
	# left
	sh1.flip_shuriken_direction(-1)
	get_parent().add_child(sh1)
	sh1.position = $LeftPos.global_position
	# right
	get_parent().add_child(sh2)
	sh2.position = $RightPos.global_position
	# up
	sh3.is_up = true
	get_parent().add_child(sh3)
	sh3.position = $UpPos.global_position
	# Attacks get more dangerous on half health
	if HP <= max_HP / 2:
		# right upper
		get_parent().add_child(sh4)
		sh4.position = $RightUp.global_position
		# left upper
		get_parent().add_child(sh5)
		sh5.position = $LeftUp.global_position
	yield(get_tree().create_timer(1), "timeout")
	is_staggered = false
	$ShootTimer.start()

func _on_Left_area_exited(area):
	yield(get_tree().create_timer(1.2), "timeout")
	velocity.x = SPEED


func _on_Right_area_exited(area):
	yield(get_tree().create_timer(1.2), "timeout")
	velocity.x = -SPEED

func _on_BufferTimer_timeout():
	is_knocked_back = false
