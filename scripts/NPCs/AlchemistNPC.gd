class_name Alchemist extends Node2D


onready var PLAYER = get_parent().get_node("Player").get_node("Area2D")
onready var player = get_parent().get_node("Player")

func _ready():
	$Label.visible = false
	$AnimationPlayer.play("Idle")
	# Dialogue configuration
	$DialogueScreen.talker.text = "Alchemist"
	$DialogueScreen.dialogue.text = "Greetings! A first timer for alchemy, I see? Feel free to refer to the Alchemy Guidebook. Our community cauldron is also free to use!"
	$DialogueScreen/Control/NinePatchRect/Button1.visible = false


func _process(delta):
	if $Area2D.overlaps_area(PLAYER) and Input.is_action_just_pressed("ui_use"):
		$DialogueScreen/Control.visible = true

		
func _on_Area2D_area_entered(area):
	if area.is_in_group("Player") and !$Label.visible:
		$Label.visible = true
		
func _on_Area2D_area_exited(area):
	if $Label.visible:
		$Label.visible = false



