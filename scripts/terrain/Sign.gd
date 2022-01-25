extends Node2D

# Input text
export var Text : String
onready var PLAYER = get_parent().get_node("Player").get_node("Area2D")

func _ready():
	$Label.visible = false
	$SignUI.visible = false
	$SignUI/RichTextLabel.bbcode_text = Text
	
func _process(delta):
	# Sign text
	if $Area2D.overlaps_area(PLAYER):
		$Label.visible = true
		if Input.is_action_pressed("ui_use"):
			$SignUI.visible = true
			$Label.visible = false
		if Input.is_action_just_released("ui_use"):
			$SignUI.visible = false
			$Label.visible = true

func _on_Area2D_area_exited(area):
	$Label.visible = false
	$SignUI.visible = false
