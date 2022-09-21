class_name AirborneStatus extends Node2D

export var time : float = 3

func _ready():
	print("airborne")
	$DestroyedTimer.start(time)
	get_parent().get_node("Area2D").add_to_group("IsAirborne")


func _on_DestroyedTimer_timeout():
	get_parent().get_node("Area2D").remove_from_group("IsAirborne")
	queue_free()
	


#func _on_Area2D_area_entered(area):
#	if area.is_in_group("Airborne"):
#		queue_free()
