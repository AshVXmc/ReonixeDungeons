class_name MagicPedestal extends Node2D

onready var AREA : Area2D = $Detector
onready var PLAYER = get_parent().get_node("Player").get_node("Area2D")
var enemy
var enemy_is_nearby : bool = false

func _ready():
	$Label.visible = false
	$Keybind.visible = false
	$CanvasLayer/Control.visible = false
	
func get_closest_enemy():
	var enemies = get_tree().get_nodes_in_group("Enemy")
	if enemies.empty(): 
		return null
	var distances = []
	for enemy in enemies:
		var distance = global_position.distance_squared_to(enemy.global_position)
		distances.append(distance)
	var min_distance = distances.min()
	var min_index = distances.find(min_distance)
	var closest_enemy = enemies[min_index]
	return closest_enemy

func _process(delta):
	$CanvasLayer/Control/Main/PrimarySkillSelect/EquippedPrimary.text = "Equipped: " + Global.player_skills["PrimarySkill"]
	$CanvasLayer/Control/Main/SecondarySkillSelect/EquippedSecondary.text = "Equipped: " + Global.player_skills["SecondarySkill"]
	$CanvasLayer/Control/Main/RangedSkillSelect/EquippedRanged.text = "Equipped: " + Global.player_skills["RangedSkill"]
	enemy = get_closest_enemy()
	if enemy and enemy.get_node("Area2D").overlaps_area($EnemyDetector):
		enemy_is_nearby = true
	else:
		enemy_is_nearby = false
	if AREA.overlaps_area(PLAYER):
		
		if Input.is_action_just_pressed("ui_use") and !$CanvasLayer/Control.visible and !enemy_is_nearby:
			Global.is_opening_an_UI = true
			get_parent().get_node("Player").is_shopping = true
			get_parent().get_node("Player").is_invulnerable = true
			$CanvasLayer/Control.visible = true
		elif Input.is_action_just_pressed("ui_use") and enemy_is_nearby:
			$EnemyIsNearby.visible = true
			yield(get_tree().create_timer(2.5), "timeout")
			$EnemyIsNearby.visible = false
	
	



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
