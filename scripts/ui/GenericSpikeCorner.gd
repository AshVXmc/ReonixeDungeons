class_name GenericSpikeCorner extends StaticBody2D

export var position_name : String = "SpikePosition"
onready var pos = get_parent().get_node(position_name)
onready var player = get_parent().get_node("Player")

func _on_Area2D_area_entered(area):
	if area.is_in_group("Player"):
		yield(get_tree().create_timer(0.4), "timeout")
		player.position.x = pos.position.x
		player.position.y = pos.position.y
