class_name ShopUI extends Control

signal item_bought(item_name, item_price)
var heart : String = "[img=32]res://assets/UI/heart.png[/img]"
var mana : String = "[img=32]res://assets/UI/mana.png[/img]"
var maxstorage : String = str(Global.max_item_storage)

func _ready():
	pass
# Uncomment this when dev is finished
#	visible = false
#	connect("item_bought", get_parent().get_parent().get_parent().get_parent().get_node("Player"), "on_Item_bought")

func _process(delta):
	pass

func _on_CloseButton_pressed():
	if $ButtonsControl.visible:
		visible = false
		get_parent().get_parent().get_parent().get_parent().get_node("Player").is_shopping = false
	elif $Skins.visible:
		$ButtonsControl.visible = true
		$Skins.visible = false

func _on_SkinsButton_pressed():
	$ButtonsControl.visible = false
	$Skins.visible = true


func _on_buy_CyberNinja_pressed():
	Global.player_unlocked_skins["CyberNinja"] = true
	$Skins/ScrollContainer/VBoxContainer/CyberNinjaControl/CyberNinja/Label.text = "Bought"
	$Skins/ScrollContainer/VBoxContainer/CyberNinjaControl/CyberNinja/Label.add_color_override("font_color", Color(1, 0.84, 0.01, 1))
	$Skins/ScrollContainer/VBoxContainer/CyberNinjaControl/OpalSprite.visible = false
	$Skins/ScrollContainer/VBoxContainer/CyberNinjaControl/Price.visible = false
	$Skins/ScrollContainer/VBoxContainer/CyberNinjaControl/CyberNinjaCheckButton.visible = true


func _on_CyberNinjaCheckButton_pressed():
	pass # Replace with function body.
