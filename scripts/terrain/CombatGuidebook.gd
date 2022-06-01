class_name CombatGuidebook extends Node2D

# Input text
onready var PLAYER = get_parent().get_node("Player").get_node("Area2D")
var page : int = 1
export var Final_Page : int = 3

func _ready():
	$Plaque/Control.visible = false
	$Label.visible = false
func _process(delta):
	if $Area2D.overlaps_area(PLAYER):
		$Label.visible = true
	else:
		$Label.visible = false
	if $Area2D.overlaps_area(PLAYER) and Input.is_action_just_pressed("ui_use"):
		$Plaque/Control.visible = true
		get_parent().get_node("Player").is_shopping = true
	$Plaque/Control/NinePatchRect/Header.bbcode_text = "========= [color=#754d27]Guide to Combat " + str(page) + "[/color] ========="
	match page:
		1:
			$Plaque/Control/NinePatchRect/Page1.visible = true
			$Plaque/Control/NinePatchRect/Page2.visible = false
			$Plaque/Control/NinePatchRect/Page3.visible = false
		2:
			$Plaque/Control/NinePatchRect/Page1.visible = false
			$Plaque/Control/NinePatchRect/Page2.visible = true
			$Plaque/Control/NinePatchRect/Page3.visible = false
		3:
			$Plaque/Control/NinePatchRect/Page1.visible = false
			$Plaque/Control/NinePatchRect/Page2.visible = false
			$Plaque/Control/NinePatchRect/Page3.visible = true
	if page == 1:
		$Plaque/Control/NinePatchRect/PrevButton.visible = false
	else:
		$Plaque/Control/NinePatchRect/PrevButton.visible = true
		
	if page == Final_Page:
		$Plaque/Control/NinePatchRect/NextButton.visible = false
	else:
		$Plaque/Control/NinePatchRect/NextButton.visible = true
func _on_Area2D_area_exited(area):
	$Label.visible = false



func _on_CloseButton_pressed():
	$Plaque/Control.visible = false
	get_parent().get_node("Player").is_shopping = false

func _on_PrevButton_pressed():
	if page != 0:
		page -= 1
	
func _on_NextButton_pressed():
	if page != Final_Page:
		page += 1



