extends Node2D

var shopui = preload("res://scenes/menus/ShopUI.tscn")

func _ready():
	$Label.visible = false
	$AnimatedSprite.play("Idle")
	
func _process(delta):
	pass
	
