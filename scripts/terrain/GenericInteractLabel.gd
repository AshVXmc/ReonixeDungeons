class_name GenericInteractLabel extends Node2D

export(String) var object_name 
export(int) var font_size = 16
var is_reading : bool = false

func _ready():
	$Label.visible = false
	var font = $Label.get_font("font")
	font.size = font_size
	$Label.add_font_override("font", font)
	# Label displays the object name plus the selected keybind for "ui_use"
	$Label.text = object_name + " [" + InputMap.get_action_list("ui_use")[0].as_text() +"]"

	
func _on_Area2D_area_entered(area):
	if area.is_in_group("Player") and !is_reading:
		$Label.visible = true

func _on_Area2D_area_exited(area):
	if area.is_in_group("Player") and !is_reading:
		$Label.visible = false
