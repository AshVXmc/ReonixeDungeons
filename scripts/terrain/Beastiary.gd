class_name Beastiary extends Node2D

# Input text
onready var PLAYER = get_parent().get_node("Player").get_node("Area2D")


func _ready():

	$Label.visible = false
	
func _physics_process(delta):
	if $Area2D.overlaps_area(PLAYER):
		$Label.visible = true
		$Keybind.visible = true
		if Input.is_action_just_pressed("ui_use"):
			$BeastiaryUI/Control.initialize_ui()
		
func _on_Area2D_area_exited(area):
	$Label.visible = false
	$Keybind.visible = false


func _on_CloseButton_pressed():
	$BeastiaryUI/Control.close_ui()
