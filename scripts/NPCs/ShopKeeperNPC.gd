class_name Shopkeeper extends Node2D

const SHOP_UI = preload("res://scenes/menus/ShopUI.tscn")
onready var PLAYER = get_parent().get_node("Player").get_node("Area2D")
signal shopping(value)

func _ready():
	connect("shopping", get_parent().get_node("Player"), "toggle_shopping")
	$Label.visible = false
	$AnimatedSprite.play("Idle")
	# Dialogue configuration
	$DialogueScreen.talker.text = "Shopkeeper"
	$DialogueScreen.dialogue.text = "Sorry, not open yet."
	$DialogueScreen/Control/NinePatchRect/Button1.visible = false
	
func _process(delta):
	if $Area2D.overlaps_area(PLAYER) and Input.is_action_just_pressed("ui_use"):
		$DialogueScreen/Control.visible = true
		get_parent().get_node("Player").is_shopping = true
		$DialogueScreen.on_Button1_pressed() 
#		var shopui := SHOP_UI.instance()
#		get_parent().add_child(shopui)
#		emit_signal("shopping", true)
		

# Override function
func on_Button1_pressed():
	print("Foobar")
func _on_Area2D_area_entered(area):
	if area.is_in_group("Player") and !$Label.visible:
		emit_signal("shopping")
		$Label.visible = true
		
func _on_Area2D_area_exited(area):
	$Label.visible = false



