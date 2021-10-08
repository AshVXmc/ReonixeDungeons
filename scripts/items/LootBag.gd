extends RigidBody2D

signal player_obtained_lootbag(rand_num)

func _ready():
	connect("player_obtained_lootbag", get_parent().get_node("Player"), "on_lootbag_obtained")

func _on_Area2D_area_entered(area):
	if area.is_in_group("Player"):
		var RNG : RandomNumberGenerator = RandomNumberGenerator.new()
		RNG.randomize()
		var rng : int = RNG.randi_range(1,5)
		emit_signal("player_obtained_lootbag", rng)
		queue_free()
