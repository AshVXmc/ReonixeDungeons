class_name ManaShrine extends Node2D
onready var PLAYER = get_parent().get_node("Player").get_node("Area2D")

func _ready():
	$LabelNode.visible = false
func _process(delta):
	if $Area2D.overlaps_area(PLAYER):
		$LabelNode.visible = true
		if Input.is_action_just_pressed("ui_use"):
			start_challenge()
			

func start_challenge():
	get_parent().initiate_enemy_wave(get_parent().WAVE)
	call_deferred('free')
