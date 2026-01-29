class_name Cauldron extends Node2D

onready var PLAYER : Area2D = get_parent().get_parent().get_node("Player").get_node("Area2D")
export var Paid : bool = false
onready var HEALTH_POTION = preload("res://assets/misc/health_pot.png")
onready var MANA_POTION = preload("res://assets/misc/mana_pot.png")
onready var POWER_POTION = preload("res://assets/misc/power_pot.png")
signal update_ingredient_inventory(ingredient_name, amount)
signal update_healthpot_ui(amount)
var potion_info : Dictionary = {
	"HealthPot" : {
		"description" : "",
		"common_dust_cost": 2,
		"goblin_scales_cost": 2
	} 
}


func _ready():
	connect("update_ingredient_inventory", get_parent().get_parent().get_node("InventoryUI/Control"), "on_ingredient_obtained")
	connect("update_healthpot_ui", get_parent().get_parent().get_node("HealthPotUI/HealthPotControl"), "on_player_healthpot_obtained")
	$Plaque/Control/HealthPotionRecipe.visible = false
	$Label.visible = false
	$Keybind.visible = false
	$Plaque/Control.visible = false

func _process(delta):
	if $Area2D.overlaps_area(PLAYER):
		$Label.visible = true
		$Keybind.visible = true
	else:
		$Label.visible = false
		$Keybind.visible = false
	if $Area2D.overlaps_area(PLAYER) and Input.is_action_just_pressed("ui_use"):
		get_tree().paused = true
		$Plaque/Control.visible = true
		get_parent().get_parent().get_node("Player").is_shopping = true


func _on_Area2D_area_exited(area):
	$Label.visible = false
	$Keybind.visible = false

func _on_CloseButton_pressed():
	get_tree().paused = false
	$Plaque/Control.visible = false
	get_parent().get_parent().get_node("Player").is_shopping = false

func update_cost_and_potioncount_ui(potion_name : String):
	match potion_name:
		"HealthPot":
			$Plaque/Control/HealthPotionRecipe/DustLabel.text = str(Global.drops_inventory["common_dust"]) + "/" + str(potion_info["HealthPot"]["common_dust_cost"])
			$Plaque/Control/HealthPotionRecipe/ScalesLabel.text = str(Global.drops_inventory["goblin_scales"]) + "/" + str(potion_info["HealthPot"]["goblin_scales_cost"])
			$Plaque/Control/HealthPotionRecipe/HealthPotionLabel.text = str(Global.healthpot_amount) + "/" + str(Global.max_item_storage)

func _on_CraftHealthPotionButton_pressed():
	if Global.healthpot_amount < Global.max_item_storage:
		if Global.drops_inventory["common_dust"] >= potion_info["HealthPot"]["common_dust_cost"] and Global.drops_inventory["goblin_scales"] >= potion_info["HealthPot"]["goblin_scales_cost"]:
			Global.healthpot_amount += 1
			emit_signal("update_healthpot_ui", Global.healthpot_amount)
			Global.drops_inventory["common_dust"] -= potion_info["HealthPot"]["common_dust_cost"]
			emit_signal("update_ingredient_inventory", "common_dust", potion_info["HealthPot"]["common_dust_cost"])
			Global.drops_inventory["goblin_scales"] -= potion_info["HealthPot"]["goblin_scales_cost"]
			emit_signal("update_ingredient_inventory", "goblin_scales", potion_info["HealthPot"]["goblin_scales_cost"])
			update_cost_and_potioncount_ui("HealthPot")
#			$Plaque/Control/Text.add_color_override("font_color", green)
#			$Plaque/Control/Text.text = "You crafted a health potion."
		else:
			$Plaque/Control/WarningLabel.add_color_override("font_color", Color(255,0,0,255))
			$Plaque/Control/WarningLabel.text = "You don't have enough ingredients to craft this."
	else:
		$Plaque/Control/WarningLabel.add_color_override("font_color", Color(255,0,0,255))
		$Plaque/Control/WarningLabel.text = "You don't have enough space to store more."


func _on_HealthPotionSelectButton_pressed():
	$Plaque/Control/HealthPotionRecipe.visible = true
	update_cost_and_potioncount_ui("HealthPot")

func _on_ManaPotionSelectButton_pressed():
	pass # Replace with function body.


func _on_StrengthPotionSelectButton_pressed():
	pass # Replace with function body.
