class_name SugarRoll extends RigidBody2D

onready var PLAYER = get_parent().get_node("Player").get_node("Area2D")
onready var REGEN_HEALTH_MODULE = preload("res://scenes/misc/RegenHealthNode.tscn")
# Called when the node enters the scene tree for the first time.

var enemies_inside_detector : Array = []
func _ready():
	pass


func _process(delta):
	if $Area2D.overlaps_area(PLAYER):
		if enemies_inside_detector.empty():
			$Label.visible = true
			$Keybind.visible = true
		else:
			$CannotEatLabel.visible = true
	else:
		$Label.visible = false
		$Keybind.visible = false
		$CannotEatLabel.visible = false
	if enemies_inside_detector.empty():
	
		if $Area2D.overlaps_area(PLAYER) and Input.is_action_just_pressed("ui_use"):
			var rgm = REGEN_HEALTH_MODULE.instance()
			rgm.character_name = Global.current_character
			# restore tick_amount of HP , every tick_duration seconds
			rgm.tick_amount = 4
			rgm.tick_duration = 2
			var coefficient : float = Global.player_perks["CreateSugarRoll"]["health"]
			# Heals 10% of the player's HP over 10 seconds
			if Global.current_character == Global.equipped_characters[0]:
				rgm.heal_per_tick_amount = (Global.max_hearts * coefficient) / 2
			elif Global.current_character == Global.equipped_characters[1]:
				rgm.heal_per_tick_amount = (Global.character_2_max_hearts * coefficient) / 2
			elif Global.current_character == Global.equipped_characters[2]:
				rgm.heal_per_tick_amount = (Global.character_3_max_hearts * coefficient) / 2
			get_parent().get_node("Player").add_child(rgm)
			call_deferred('free')
#	print(enemies_inside_detector)

func _on_EnemyDetectorArea2D_area_entered(area):
	if area.is_in_group("Enemy"):
		enemies_inside_detector.append(area)


func _on_EnemyDetectorArea2D_area_exited(area):
	if area.is_in_group("Enemy"):
		enemies_inside_detector.erase(area)
