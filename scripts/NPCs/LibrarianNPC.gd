class_name Librarian extends Node2D


onready var PLAYER = get_parent().get_node("Player").get_node("Area2D")
onready var player = get_parent().get_node("Player")

func _ready():
	$Label.visible = false
	$AnimationPlayer.play("Idle")
	# Dialogue configuration
	$DialogueScreen.talker.text = "Shopkeeper"
	$DialogueScreen.dialogue.text = "H-hi, welcome to the library. We don't get many visitors here, but feel free to look around and write in your journal about your adventures."
	$DialogueScreen/Control/NinePatchRect/Button1.visible = false


func _process(delta):
	if $Area2D.overlaps_area(PLAYER) and Input.is_action_just_pressed("ui_use"):
		$DialogueScreen/Control.visible = true

		
func _on_Area2D_area_entered(area):
	if area.is_in_group("Player") and !$Label.visible:
		$Label.visible = true
		
func _on_Area2D_area_exited(area):
	$Label.visible = false



