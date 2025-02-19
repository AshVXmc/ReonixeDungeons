class_name AirborneStatus extends Node2D

onready var time : float = 5.0
func _ready():
	$DestroyedTimer.wait_time = time
	$DestroyedTimer.start()
	get_parent().get_node("Area2D").add_to_group("IsAirborne")
	
	if get_parent().is_in_group("AirborneImmune"):
		get_parent().get_node("Area2D").remove_from_group("IsAirborne")
		call_deferred('free')

func _on_DestroyedTimer_timeout():
	get_parent().get_node("Area2D").remove_from_group("IsAirborne")
	call_deferred('free')
	


func _on_Area2D_area_entered(area):
	
	if area.is_in_group("RemoveAirborne"):
		get_parent().get_node("Area2D").remove_from_group("IsAirborne")
		call_deferred('free')

	if area.is_in_group("Sword") or area.is_in_group("Fireball") or area.is_in_group("Ice"):
		$DestroyedTimer.stop()
		$DestroyedTimer.start()
	
	

func _on_MaxDestroyedTimer_timeout():
	get_parent().get_node("Area2D").remove_from_group("IsAirborne")
	call_deferred('free')
