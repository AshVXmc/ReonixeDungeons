class_name Sign extends Node2D

# Input text
export var Text : String
onready var PLAYER = get_parent().get_node("Player").get_node("Area2D")


func _ready():
	$Label.visible = false
	$Keybind.visible = false
	$DialogueScreen.dialogue.text = Text
	$DialogueScreen.talker.text = ""
	$DialogueScreen/Control/NinePatchRect/Button1.visible = false
	
func _process(delta):
	if $Area2D.overlaps_area(PLAYER):
		$Label.visible = true
		$Keybind.visible = true
		
	else:
		$Label.visible = false
		$Keybind.visible = false
	if $Area2D.overlaps_area(PLAYER) and Input.is_action_just_pressed("ui_use"):
		$DialogueScreen/Control.visible = true
		get_parent().get_node("Player").is_shopping = true
		
func _on_Area2D_area_exited(area):
	$Label.visible = false
	$Keybind.visible = false



func _on_Area2D_area_entered(area):
	pass # Replace with function body.
