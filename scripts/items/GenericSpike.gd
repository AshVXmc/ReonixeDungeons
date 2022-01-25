extends StaticBody2D

export var pos_name : String
onready var pos = get_parent().get_node("SpikePosition")
onready var player = get_parent().get_node("Player")

# This is a generic spike type tile, use it for levels
# Put a Position2D node called "SpikePosition" and set it to where you want the player to teleport

func _on_Area2D_area_entered(area):
	if area.is_in_group("Player"):
		yield(get_tree().create_timer(0.4), "timeout")
		player.position.x = pos.position.x
		player.position.y = pos.position.y


