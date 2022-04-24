class_name DungeonPortal extends Node2D

# Input text
onready var PLAYER = get_parent().get_node("Player").get_node("Area2D")
onready var deactivated = preload("res://assets/terrain/hub_level/portal_closed.png")
onready var activated = preload("res://assets/terrain/hub_level/portal_opened.png")
export var Portal_ID : int 
# 0 = Hub portal
# 1 = Level 5

func _ready():
	$Label.visible = false
	$Plaque/Control.visible = false


func _process(delta):
	if !Global.activated_portals.has("Level5"):
		$Plaque/Control/NinePatchRect/Level5.visible = false
	if $Area2D.overlaps_area(PLAYER):
		$Label.visible = true
	else:
		$Label.visible = false
	if $Area2D.overlaps_area(PLAYER) and Input.is_action_just_pressed("ui_use"):
		$Plaque/Control.visible = true
		get_parent().get_node("Player").is_shopping = true
		
func _on_Area2D_area_exited(area):
	$Label.visible = false




func _on_Area2D_area_entered(area):
	pass # Replace with function body.


func _on_CloseButton_pressed():
	$Plaque/Control.visible = false
	get_parent().get_node("Player").is_shopping = false

func _on_HubLevel_pressed():
	get_parent().get_node("SceneTransition/ColorRect").visible = true
	get_parent().get_node("SceneTransition").transition()
	yield(get_tree().create_timer(1), "timeout")
	get_tree().change_scene("res://scenes/levels/HubLevel.tscn")


func _on_Level5_pressed():
	get_parent().get_node("SceneTransition/Colorrect").visible = true
	get_parent().get_node("SceneTransition").transition()
	yield(get_tree().create_timer(1), "timeout")
	get_tree().change_scene("res://scenes/levels/Level5.tscn")

