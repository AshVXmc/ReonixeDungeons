extends Node2D

onready var full = preload("res://assets/terrain/mana_shrine_full.png")
onready var empty = preload("res://assets/terrain/mana_shrine_empty.png")
onready var PLAYER = get_parent().get_node("Player").get_node("Area2D")
signal manashrine_heal()

func _ready():
	connect("manashrine_heal", get_parent().get_node("Player"), "on_manashrine_toggled")
	$Sprite.texture = full
	$Label.visible = false
func _process(delta):
	if $Area2D.overlaps_area(PLAYER):
		if Input.is_action_just_pressed("ui_use"):
			emit_signal("manashrine_heal")

func _on_Area2D_area_exited(area):
	$Label.visible = false


func _on_Area2D_area_entered(area):
	if area.is_in_group("Player") and !$Label.visible:
		$Label.visible = true
