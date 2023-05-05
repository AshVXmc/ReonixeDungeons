class_name GenericInteractLabel extends Node2D

export(String) var object_name 


func _ready():
#	$RichTextLabel.visible = false
	# Label displays the object name plus the selected keybind for "ui_use"
	$RichTextLabel.bbcode_text = object_name + "[color=#315fff][" + InputMap.get_action_list("ui_use")[0].as_text() +"][/color]"
