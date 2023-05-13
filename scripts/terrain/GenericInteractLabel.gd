class_name GenericInteractLabel extends Node2D

export(String) var object_name 


func _ready():
	$Label.visible = false
	# Label displays the object name plus the selected keybind for "ui_use"
	$Label.text = object_name + " [" + InputMap.get_action_list("ui_use")[0].as_text() +"]"


func _on_Area2D_area_entered(area):
	if area.is_in_group("Player"):
		$Label.visible = true




func _on_Area2D_area_exited(area):
	if area.is_in_group("Player"):
		$Label.visible = false
