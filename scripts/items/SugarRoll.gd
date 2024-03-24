class_name SugarRoll extends RigidBody2D

onready var PLAYER = get_parent().get_node("Player").get_node("Area2D")
onready var REGEN_HEALTH_MODULE = preload("res://scenes/misc/RegenHealthNode.tscn")
# Called when the node enters the scene tree for the first time.
var enemy_detected : bool = false
var enemies_inside_detector : Array = []
func _ready():
	pass


func _process(delta):
	if enemies_inside_detector.empty():
		if $Area2D.overlaps_area(PLAYER):
			$Label.visible = true
			$Keybind.visible = true
		else:
			$Label.visible = false
			$Keybind.visible = false
		if $Area2D.overlaps_area(PLAYER) and Input.is_action_just_pressed("ui_use"):
			var rgm = REGEN_HEALTH_MODULE.instance()
			rgm.character_name = Global.current_character
			# restore 4, 1 every second
			rgm.tick_amount = 5
			rgm.tick_duration = 3
			
			get_parent().get_node("Player").add_child(rgm)
			call_deferred('free')
	print(enemies_inside_detector)

func _on_Area2D_area_entered(area):
	if area.is_in_group("Enemy"):
		enemies_inside_detector.append(area)


func _on_Area2D_area_exited(area):
	if area.is_in_group("Enemy"):
		enemies_inside_detector.erase(area)
