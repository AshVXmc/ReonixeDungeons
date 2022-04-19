# Reusable Dialogue Screen scene for NPCs and misc uses.
class_name DialogueScreen extends CanvasLayer

onready var talker = $Control/NinePatchRect/Talking
onready var dialogue = $Control/NinePatchRect/Dialogue

func _ready():
	$Control.visible = false
func _on_CloseButton_pressed():
	$Control.visible = false
	get_parent().get_parent().get_node("Player").is_shopping = false


func _on_Button1_pressed():
	get_parent().on_Button1_pressed()
