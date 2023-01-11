class_name Librarian extends Node2D


onready var PLAYER = get_parent().get_node("Player").get_node("Area2D")
onready var player = get_parent().get_node("Player")

func _ready():
	$Label.visible = false
	$Keybind.visible = false
	$AnimationPlayer.play("Idle")
	# Dialogue configuration
#	$DialogueScreen.talker.text = "Librarian"
#	$DialogueScreen.dialogue.text = "Welcome to the library!  We provide you with extensive guides for your adventures and a private journal for you to write in. Feel free to come in at any time of the day!"
#	$DialogueScreen/Control/NinePatchRect/Button1.visible = false


func _process(delta):
	if $Area2D.overlaps_area(PLAYER) and Input.is_action_just_pressed("ui_use"):
#		$DialogueScreen/Control.visible = true
		player.is_shopping = true

		
func _on_Area2D_area_entered(area):
	if area.is_in_group("Player") and !$Label.visible:
		$Label.visible = true
		$Keybind.visible = true
		
func _on_Area2D_area_exited(area):
	if $Label.visible:
		$Label.visible = false
		$Keybind.visible = false



