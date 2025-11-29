class_name GoddessTrialsShrine extends Node2D

onready var PLAYER = get_parent().get_node("Player").get_node("Area2D")
var is_active : bool = true
signal start_stage(stage, wave)


func _ready():

	$LabelNode.visible = false
	connect("start_stage", get_parent(), "initiate_enemy_wave")
	

func _process(delta):
	if is_active and $Area2D.overlaps_area(PLAYER) and Input.is_action_just_pressed("ui_use"):
		start_challenge(Global.goddess_trials_stages["CurrentStage"], 1)
		

func start_challenge(stage_index : int, wave : int = 1):
	emit_signal("start_stage", stage_index, wave)
	deactivate_shrine()

func activate_shrine():
	is_active = true
	$Area2D/CollisionShape2D.disabled = false
	visible = true

func deactivate_shrine():
	is_active = false
	$Area2D/CollisionShape2D.disabled = true
	visible = false

func _on_Area2D_area_entered(area):
	if area.is_in_group("Player") and !$LabelNode.visible:
		emit_signal("shopping")
		$LabelNode.visible = true

func _on_Area2D_area_exited(area):
	if area.is_in_group("Player"):
		$LabelNode.visible = false



