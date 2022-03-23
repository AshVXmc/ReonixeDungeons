class_name Shopkeeper extends Node2D

const SHOP_UI = preload("res://scenes/menus/ShopUI.tscn")
onready var PLAYER = get_parent().get_node("Player").get_node("Area2D")
signal shopping(value)

func _ready():
	connect("shopping", get_parent().get_node("Player"), "toggle_shopping")
	$Label.visible = false
	$AnimatedSprite.play("Idle")
	
func _process(delta):
	if $Area2D.overlaps_area(PLAYER) and Input.is_action_just_pressed("ui_use"):
		var shopui := SHOP_UI.instance()
		get_parent().add_child(shopui)
		emit_signal("shopping", true)
		

func _on_Area2D_area_entered(area):
	if area.is_in_group("Player") and !$Label.visible:
		emit_signal("shopping")
		$Label.visible = true
		
func _on_Area2D_area_exited(area):
	$Label.visible = false



