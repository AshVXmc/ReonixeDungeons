class_name Shopkeeper extends Node2D

const SHOP_UI = preload("res://scenes/menus/ShopUI.tscn")
signal shopping(value)

onready var PLAYER = get_parent().get_node("Player").get_node("Area2D")
onready var player = get_parent().get_node("Player")

func _ready():
	connect("shopping", get_parent().get_node("Player"), "toggle_shopping")
	$Label.visible = false
	$Keybind.visible = false
	$AnimatedSprite.play("Idle")


func _process(delta):
	if $Area2D.overlaps_area(PLAYER) and Input.is_action_just_pressed("ui_use") and !$ShopUI/CanvasLayer/Main.visible:
#		player.is_shopping = true
		var HUBLEVEL_SHOP_DIALOGUE = Dialogic.start("HubLevelShop")
		HUBLEVEL_SHOP_DIALOGUE.connect("timeline_end",self , "end_of_dialogue")
		add_child(HUBLEVEL_SHOP_DIALOGUE)

func end_of_dialogue(timeline_name):
	player.is_shopping = false

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
		$Keybind.visible = true
		
func _on_Area2D_area_exited(area):
	if area.is_in_group("Player"):
		$Label.visible = false
		$Keybind.visible = false



