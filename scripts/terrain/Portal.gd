class_name DungeonPortal extends Node2D

# Input text
onready var PLAYER = get_parent().get_node("Player").get_node("Area2D")
export var Portal_ID : int 
# 0 = Hub portal
# 1 = Level 5

func _ready():
	$AnimatedSprite.play("default")
	$Label.visible = false
	$Plaque/Control.visible = false
	$Particles2D.visible = false

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
	pass


func _on_CloseButton_pressed():
	$Plaque/Control.visible = false
	get_parent().get_node("Player").is_shopping = false

func _on_HubLevel_pressed():
	teleport_to_level("res://scenes/levels/HubLevel.tscn")


func _on_Level5_pressed():
	teleport_to_level("res://scenes/levels/Level5.tscn")

func teleport_to_level(level_path : String):
	$Plaque/Control.visible = false
	$Particles2D.visible = true
	$Particles2D.emitting = true
	$Particles2D.one_shot = false
	get_parent().get_node("SceneTransition/ColorRect").visible = true
	get_parent().get_node("SceneTransition").transition()
	yield(get_tree().create_timer(1), "timeout")
	get_tree().change_scene(level_path)
