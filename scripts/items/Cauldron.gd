class_name Cauldron extends Node2D

onready var PLAYER = get_parent().get_node("Player").get_node("Area2D")
export var Paid : bool = false
signal add_item_to_player(item_name, common_dust, goblin_scales)
var green : Color = Color(35,255,0,2)
var red : Color = Color(255,0,0,255)
var white : Color = Color(255,255,255,255)

func _ready():
	connect("add_item_to_player", get_parent().get_node("Player"), "on_Item_crafted")
	$Label.visible = false
	$Keybind.visible = false
	$Plaque/Control/Text.add_color_override("font_color", white)
	$Plaque/Control.visible = false
func _process(delta):
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


func _on_CraftHealthPot_pressed():
	if Global.healthpot_amount < Global.max_item_storage:
		if Global.common_monster_dust_amount >= 6 and Global.goblin_scales_amount >= 3:
			emit_signal("add_item_to_player","HealthPot", 6,3)
			$Plaque/Control/Text.add_color_override("font_color", green)
			$Plaque/Control/Text.text = "You crafted a health potion."
		else:
			$Plaque/Control/Text.add_color_override("font_color", red)
			$Plaque/Control/Text.text = "Not enough materials to craft this."
	else:
		$Plaque/Control/Text.add_color_override("font_color", red)
		$Plaque/Control/Text.text = "Not enough space to store more."


func _on_CraftManaPot_pressed():
	if Global.manapot_amount < Global.max_item_storage:
		if Global.common_monster_dust_amount >= 9:
			emit_signal("add_item_to_player","ManaPot", 9, 0)
			$Plaque/Control/Text.add_color_override("font_color", green)
			$Plaque/Control/Text.text = "You crafted a mana potion."
		else:
			$Plaque/Control/Text.add_color_override("font_color", red)
			$Plaque/Control/Text.text = "Not enough materials to craft this."
	else:
		$Plaque/Control/Text.add_color_override("font_color", red)
		$Plaque/Control/Text.text = "Not enough space to store more."
