class_name WeaknessDisplayComponent extends Node2D


func _ready():
	update_weakness_display()

func update_weakness_display():
	if get_parent() != null:
		if get_parent().phys_res < 0:
			get_node("WeaknessSprite" + str(get_next_empty_sprite())).texture = load("res://assets/UI/physical_type_icon.png")
		if get_parent().fire_res < 0:
			get_node("WeaknessSprite" + str(get_next_empty_sprite())).texture = load("res://assets/UI/fire_type_icon.png")
		if get_parent().ice_res < 0:
			get_node("WeaknessSprite" + str(get_next_empty_sprite())).texture = load("res://assets/UI/ice_type_icon.png")
		if get_parent().earth_res < 0:
			get_node("WeaknessSprite" + str(get_next_empty_sprite())).texture = load("res://assets/UI/earth_type_icon.png")


func get_next_empty_sprite() -> int:
	var counter : int = 1
	for s in get_children():
		if s.texture == null:
			return counter
		counter += 1
	return -1 # invalid
