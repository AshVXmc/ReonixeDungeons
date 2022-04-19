class_name DungeonPortal extends Node2D

# Input text
onready var PLAYER = get_parent().get_node("Player").get_node("Area2D")
onready var deactivated = preload("res://assets/terrain/hub_level/portal_closed.png")
onready var activated = preload("res://assets/terrain/hub_level/portal_opened.png")

func _ready():
	$Label.visible = false
	$DialogueScreen.dialogue.text = "An ancient portal frame gathering dust. It doesn't seem to do anything right now."
	$DialogueScreen.talker.text = ""
	$DialogueScreen/Control/NinePatchRect/Button1.visible = false
	
func _process(delta):
	if $Area2D.overlaps_area(PLAYER):
		$Label.visible = true
	else:
		$Label.visible = false
	if $Area2D.overlaps_area(PLAYER) and Input.is_action_just_pressed("ui_use"):
		$DialogueScreen/Control.visible = true
		get_parent().get_node("Player").is_shopping = true
		
func _on_Area2D_area_exited(area):
	$Label.visible = false




func _on_Area2D_area_entered(area):
	pass # Replace with function body.
