extends Node2D

onready var full = preload("res://assets/terrain/mana_shrine_full.png")
onready var empty = preload("res://assets/terrain/mana_shrine_empty.png")
onready var PLAYER = get_parent().get_node("Player").get_node("Area2D")


func _process(delta):
	$Label.visible = false

func _on_Area2D_area_exited(area):
	if $Area2D.overlaps_area(PLAYER):
		$Label.visible = true
		if Input.is_action_pressed("ui_use"):
			$Label.visible = false
		if Input.is_action_just_released("ui_use"):
			$Label.visible = true
