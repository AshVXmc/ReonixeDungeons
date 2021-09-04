extends Node2D
signal player_entered(talkerID)

func _ready():
	connect("player_entered", get_parent().get_node("DialogueScreen"), "talk")


func _on_Area2D_area_entered(area):
	if area.is_in_group("Player"):
		# Token = 0
		emit_signal("player_entered", 0)
