class_name GenericInteractable extends Node2D

export(String) var dialogic_timeline
onready var PLAYER = get_parent().get_node("Player").get_node("Area2D")
onready var player = get_parent().get_node("Player")

# In case you'd forgotten, the variable "is_shopping" in the player node is supposed
# to immobilize the player in place until it's set to false.

func _process(delta):
	if $Area2D.overlaps_area(PLAYER) and Input.is_action_just_pressed("ui_use"):
		player.is_shopping = true
		add_dialogue()

func end_of_dialogue(timeline_name):
	player.is_shopping = false
	print("unstuck")

func add_dialogue():
	var DIALOGUE = Dialogic.start(dialogic_timeline)
	DIALOGUE.connect("timeline_end",self , "end_of_dialogue")
	add_child(DIALOGUE)
