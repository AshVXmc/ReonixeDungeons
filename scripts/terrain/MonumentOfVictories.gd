class_name MonumentOfVictories extends Node2D

onready var PLAYER = get_parent().get_node("Player").get_node("Area2D")
var green = Color(35,255,0,2)

func _ready():
	$Label.visible = false
	$Keybind.visible = false
	$Plaque/Control.visible = false
func _process(delta):
	if Global.masked_goblin_defeated:
		$Plaque/Control/NinePatchRect/BossSlot1/Label.add_color_override("default_color", green)
		$Plaque/Control/NinePatchRect/BossSlot1/Label.text = "Masked Goblin"
		$Plaque/Control/NinePatchRect/BossSlot1/BossTrophy.visible = true
		$Plaque/Control/NinePatchRect/BossSlot1/Locked.visible = false
	if $Area2D.overlaps_area(PLAYER):
		$Label.visible = true
		$Keybind.visible = true
	else:
		$Label.visible = false
		$Keybind.visible = false
	if $Area2D.overlaps_area(PLAYER) and Input.is_action_just_pressed("ui_use"):
		$Plaque/Control.visible = true
		get_parent().get_node("Player").is_shopping = true


func _on_Area2D_area_exited(area):
	$Label.visible = false
	$Keybind.visible = false

func _on_CloseButton_pressed():
	$Plaque/Control.visible = false
	get_parent().get_node("Player").is_shopping = false
