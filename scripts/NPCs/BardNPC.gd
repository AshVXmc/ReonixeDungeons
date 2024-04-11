class_name BardNPC extends Node2D

onready var PLAYER = get_parent().get_node("Player").get_node("Area2D")
onready var player = get_parent().get_node("Player")

signal shopping(value)

func _ready():
	connect("shopping", get_parent().get_node("Player"), "toggle_shopping")
	$Label.visible = false
	$Keybind.visible = false
#	$AnimationPlayer.play("Idle")

func _process(delta):
	if $Area2D.overlaps_area(PLAYER) and Input.is_action_just_pressed("ui_use"):
		player.is_shopping = true
		var HUBLEVEL_TAVERN_BARD_DIALOGUE = Dialogic.start("HubLevelTavernBard")
		HUBLEVEL_TAVERN_BARD_DIALOGUE.connect("timeline_end",self , "end_of_dialogue")
		add_child(HUBLEVEL_TAVERN_BARD_DIALOGUE)

func end_of_dialogue():
	pass
