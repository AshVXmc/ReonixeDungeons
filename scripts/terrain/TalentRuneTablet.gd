class_name TalentRuneTablet extends Node2D

onready var PLAYER = get_parent().get_node("Player").get_node("Area2D")
func _process(delta):
	if $Area2D.overlaps_area(PLAYER) and Input.is_action_just_pressed("ui_use"):
		print("ooo rune tablet glow ooo")
