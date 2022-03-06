extends Node2D

export var chestID : int
export var Opals : int
var hasbeenopened = false
onready var AREA : Area2D = $Area2D
onready var PLAYER = get_parent().get_node("Player").get_node("Area2D")

signal give_opals(amount)
func _ready():
	connect("give_opals", get_parent().get_node("Player"), "get_opals")
	$Label.visible = false

func _process(_delta):
	if !Global.opened_chests.has(chestID):
		$AnimatedSprite.play("Idle")
	else:
		hasbeenopened = true
	if hasbeenopened:
		$AnimatedSprite.play("Opened")
	if AREA.overlaps_area(PLAYER) and Input.is_action_just_pressed("ui_use") and !Global.opened_chests.has(chestID) and !hasbeenopened:
		Global.opened_chests.append(chestID)
		emit_signal("give_opals", Opals)



func _on_Area2D_area_entered(area):
	if area.is_in_group("Player") and !$Label.visible and !Global.opened_chests.has(chestID):
		$Label.visible = true

func _on_Area2D_area_exited(area):
	$Label.visible = false
