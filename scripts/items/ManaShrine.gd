class_name ManaShrine extends Node2D
onready var PLAYER = get_parent().get_node("Player").get_node("Area2D")

func _ready():
	$LevelSelectionUI/Control.visible = false
	$LabelNode.visible = false

func _process(delta):
	if $Area2D.overlaps_area(PLAYER):
		if Input.is_action_just_pressed("ui_use"):
#			start_challenge()
			$LevelSelectionUI/Control.visible = true
			get_tree().paused = true
			$LevelSelectionUI.layer = 3
			

func start_challenge(stage : int):
	get_parent().STAGE = stage
	get_parent().initiate_enemy_wave(get_parent().STAGE, get_parent().WAVE)
	call_deferred('free')


func _on_Area2D_area_entered(area):
	if area.is_in_group("Player") and !$LabelNode.visible:
		emit_signal("shopping")
		$LabelNode.visible = true

func _on_Area2D_area_exited(area):
	if area.is_in_group("Player"):
		$LabelNode.visible = false


func _on_Stage1_pressed():
	$LevelSelectionUI/Control.visible = false
	get_tree().paused = false
	$LevelSelectionUI.layer = 1
	start_challenge(1)

func _on_Stage2_pressed():
	$LevelSelectionUI/Control.visible = false
	get_tree().paused = false
	$LevelSelectionUI.layer = 1
	start_challenge(2)
