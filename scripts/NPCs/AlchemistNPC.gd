class_name Alchemist extends Node2D

onready var PLAYER = get_parent().get_node("Player").get_node("Area2D")
onready var player = get_parent().get_node("Player")

func _ready():
	$Label.visible = false
	$Keybind.visible = false
	$AnimationPlayer.play("Idle")
	# Dialogue configuration



func _process(delta):
	if $Area2D.overlaps_area(PLAYER) and Input.is_action_just_pressed("ui_use"):
		player.is_shopping = true
		var HUBLEVEL_SHOP_DIALOGUE = Dialogic.start("HubLevelShop")
		HUBLEVEL_SHOP_DIALOGUE.connect("timeline_end",self , "end_of_dialogue")
		add_child(HUBLEVEL_SHOP_DIALOGUE)

		
func _on_Area2D_area_entered(area):
	if area.is_in_group("Player") and !$Label.visible:
		$Label.visible = true
		$Keybind.visible = true
func _on_Area2D_area_exited(area):
	if $Label.visible:
		$Label.visible = false
		$Keybind.visible = false



