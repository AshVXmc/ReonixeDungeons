class_name MagicPedestal extends Node2D

onready var AREA : Area2D = $Detector
onready var PLAYER = get_parent().get_node("Player").get_node("Area2D")

func _ready():
	$Label.visible = false
	$Keybind.visible = false
	$CanvasLayer/Control.visible = false
	

func _process(delta):
	$CanvasLayer/Control/Main/PrimarySkillSelect/EquippedPrimary.text = "Equipped: " + Global.player_skills["PrimarySkill"]
	$CanvasLayer/Control/Main/SecondarySkillSelect/EquippedSecondary.text = "Equipped: " + Global.player_skills["SecondarySkill"]
	$CanvasLayer/Control/Main/RangedSkillSelect/EquippedRanged.text = "Equipped: " + Global.player_skills["RangedSkill"]
	if AREA.overlaps_area(PLAYER):
		if Input.is_action_just_pressed("ui_use") and !$CanvasLayer/Control.visible:
			Global.is_opening_an_UI = true
			get_parent().get_node("Player").is_shopping = true
			get_parent().get_node("Player").is_invulnerable = true
			$CanvasLayer/Control.visible = true



func _on_Detector_area_exited(area):
	$Label.visible = false
	$Keybind.visible = false


func _on_CloseButton_pressed():
	Global.is_opening_an_UI = false
	get_parent().get_node("Player").is_shopping = false
	get_parent().get_node("Player").is_invulnerable = false
	$CanvasLayer/Control.visible = false


func _on_PrimarySkillSelect_pressed():
	$CanvasLayer/PrimarySkill.visible = true


func _on_PrimaryCloseButton_pressed():
	$CanvasLayer/PrimarySkill.visible = false


func _on_Detector_area_entered(area):
	if area.is_in_group("Player") and !$Label.visible:
		$Label.visible = true
		$Keybind.visible = true
