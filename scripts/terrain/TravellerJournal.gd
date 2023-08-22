class_name TravellerJournal extends Node2D

# Input text
onready var PLAYER = get_parent().get_node("Player").get_node("Area2D")


func _ready():
	$Plaque/Control.visible = false
	$Label.visible = false
	$Plaque/Control/NinePatchRect/KillCount.text = "Kill Count: " + str(Global.enemies_killed)
	$Plaque/Control/NinePatchRect/OpenedChests.text = "Opened Chests: " + str(Global.opened_chests.size())
func _process(delta):
	if $Area2D.overlaps_area(PLAYER):
		$Label.visible = true
	else:
		$Label.visible = false
	if $Area2D.overlaps_area(PLAYER) and Input.is_action_just_pressed("ui_use"):
		$Plaque/Control.visible = true
		get_parent().get_node("Player").is_shopping = true
		
func _on_Area2D_area_exited(area):
	$Label.visible = false



func _on_CloseButton_pressed():
	$Plaque/Control.visible = false
	get_parent().get_node("Player").is_shopping = false
