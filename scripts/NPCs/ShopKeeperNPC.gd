class_name Shopkeeper extends Node2D

const SHOP_UI = preload("res://scenes/menus/ShopUI.tscn")
signal shopping(value)

onready var PLAYER = get_parent().get_node("Player").get_node("Area2D")
onready var player = get_parent().get_node("Player")

func _ready():
#	if get_parent().get_parent().filename == "res://scenes/levels/HubLevel.tscn":
#		PLAYER = get_parent().get_parent().get_node("Player").get_node("Area2D")
#		player = get_parent().get_parent().get_node("Player")
#	else:
#		PLAYER = get_parent().get_node("Player").get_node("Area2D")
#		player = get_parent().get_node("Player")
	connect("shopping", get_parent().get_node("Player"), "toggle_shopping")
	$Label.visible = false
	$AnimatedSprite.play("Idle")
	# Dialogue configuration
	$DialogueScreen.talker.text = "Shopkeeper"
	$DialogueScreen.talker.add_color_override("font_color", Color(103, 7, 130))
	if get_parent().filename == "res://scenes/levels/HubLevel.tscn":
		$DialogueScreen.dialogue.text = "Welcome! I sell all kinds of goods to aid you in your journeys. You might find me wandering the dungeons below, but I usually only sell parts of my items down there."
	else:
		$DialogueScreen.dialogue.text = "Ah, its you, thank goodness. I've been trying to sell some of my goods to the locals, but the only 'locals' here are the monsters. Would you like to take a look?"
	$DialogueScreen/Control/NinePatchRect/Button1.visible = true
	$DialogueScreen/Control/NinePatchRect/Button1/Text.text = "I'd like to buy your wares."

func _process(delta):
	if $Area2D.overlaps_area(PLAYER) and Input.is_action_just_pressed("ui_use"):
		$DialogueScreen/Control.visible = true
		player.is_shopping = true
#		var shopui := SHOP_UI.instance()
#		get_parent().add_child(shopui)
#		emit_signal("shopping", true)
		

# Override function
# Open shop UI
func on_Button1_pressed():
	print("Opened Shop")
	$ShopUI/CanvasLayer/Main.visible = true
	emit_signal("shopping", true)
	$DialogueScreen/Control.visible = false
func _on_Area2D_area_entered(area):
	if area.is_in_group("Player") and !$Label.visible:
		emit_signal("shopping")
		$Label.visible = true
		
func _on_Area2D_area_exited(area):
	$Label.visible = false



