class_name IceLance extends Area2D

signal add_mana_to_glaciela(amount)
onready var mana_granted : float = 0.125

var SPEED = 750
const steer_force = 880
var attack : int = 5
var target = null
var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO
var direction : int = 1
onready var atkbonus
var tundra_sigil_atkbonus : int = 1

var ATTACK = Global.glaciela_attack



# How the skill works:
# The player throws a spinning ice lance forwards (left or right).
# After some time, the ice lance homes towards the player and gets destroyed upon contact with the player.
func _ready():
	
	add_to_group(str(tundra_sigil_atkbonus * ATTACK * (Global.glaciela_skill_multipliers["IceLance"] / 100)))
	$FreezeGaugeArea.add_to_group(str(Global.glaciela_skill_multipliers["IceLanceFreezeGauge"]))
#	add_to_group("IceGaugeTwo")
	connect("add_mana_to_glaciela", get_parent().get_node("Player/CharacterManager/Glaciela"), "change_mana_value")
		
func _physics_process(delta):
	if !$TargetPlayerTimer.is_stopped():
		if direction == 1:
			velocity.x = SPEED * delta
		elif direction == -1:
			velocity.x = -SPEED * delta
		translate(velocity)
	else:
#		SPEED *= 2
		target = get_parent().get_node("Player")
		if target:
			acceleration += seek_player()
			velocity += acceleration * delta
			velocity = velocity.clamped(SPEED)
			position += velocity * delta
	
	if Global.current_character == "Glaciela" and !$TargetPlayerTimer.is_stopped():
		if Input.is_action_just_pressed("secondary_skill"):
			$TargetPlayerTimer.stop()
func seek_player():
	var steer = Vector2.ZERO
	if target:
		var desired = (target.position - position).normalized() * SPEED
		steer = (desired - velocity).normalized() * steer_force
		return steer




func _on_PlayerDetector_area_entered(area):
	if area.is_in_group("Player") and $TargetPlayerTimer.is_stopped():
		call_deferred('free')


func _on_DestroyedTimer_timeout():
	call_deferred('free')


func _on_IceLance_body_entered(body):
	if body.is_in_group("EnemyEntity"):
		emit_signal("add_mana_to_glaciela", mana_granted * tundra_sigil_atkbonus)
		print("mana granted")
