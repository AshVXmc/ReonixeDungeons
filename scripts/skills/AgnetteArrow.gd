class_name AgnetteArrow extends KinematicBody2D

const MAX_SPEED : int = 800
var SPEED : int = MAX_SPEED
var velocity := Vector2()
export (int) var x_direction = 1
const TYPE = "Physical"

export (bool) var up : bool = false
export (bool) var down : bool = false
signal add_mana_to_agnette(amount)
onready var mana_granted : float = 0.2
const AIRBORNE_STATUS : PackedScene = preload("res://scenes/status_effects/AirborneStatus.tscn")
export (bool) var knocks_enemies_airborne = false


func _ready():
	connect("add_mana_to_agnette", get_parent().get_node("Player/CharacterManager/Agnette"), "change_mana_value")
	if TYPE == "Earth":
		mana_granted = 0.5
func _physics_process(delta):
#	position += transform.x * SPEED * delta * x_direction
	$Sprite.flip_h = true if x_direction < 0 else false
	velocity.x = SPEED * delta * x_direction
	
	if up:
		velocity.y = -3 * x_direction
		rotation_degrees = -30
	elif down:
		velocity.y = 3 * x_direction
		rotation_degrees = 30
	translate(velocity)


func flip_arrow_direction(fb_direction : int):
	# SouthEast = 5
	x_direction = fb_direction
	
func knock_airborne(target):
	if target and weakref(target).get_ref() != null and !target.is_in_group("IsAirborne") and !target.get_parent().is_in_group("Armored"):
		var airborne_status := AIRBORNE_STATUS.instance()
		target.get_parent().add_child(airborne_status)
#		print("NEEEGA")


func _on_Area2D_area_entered(area):
	if area.is_in_group("Enemy"):
		emit_signal("add_mana_to_agnette", mana_granted)
		call_deferred('free')


func _on_Area2D_body_entered(body):
	if body.is_in_group("Tilemap") and !up and !down:
		call_deferred('free')
	if body.is_in_group("Enemy") and knocks_enemies_airborne:
		knock_airborne(body.get_node("Area2D"))


func _on_Timer_timeout():
	call_deferred('free')



func _on_Area2D_area_exited(area):
	if area.is_in_group("TempusTardus"):
		SPEED = MAX_SPEED
