class_name LootBag extends RigidBody2D

signal player_obtained_lootbag()

func _ready():
	connect("player_obtained_lootbag", get_parent().get_node("Player"), "on_lootbag_obtained")

func _on_Area2D_area_entered(area):
	if area.is_in_group("Player"):
		emit_signal("player_obtained_lootbag")
		queue_free()
