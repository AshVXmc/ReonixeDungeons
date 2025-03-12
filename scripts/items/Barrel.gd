extends Sprite

# Barrels have a chance to be randomly converted into explosive barrels or 
# dissapear from the map to spice up the levels a bit 
var broken : bool = false
export var MAX : int = 5
export var MIN : int = 1
signal give_opals(opals)

func _ready():
	connect("give_opals", get_parent().get_node("Player"), "get_opals")

	
func _on_Area2D_area_entered(area):
	if area.is_in_group("Sword") or area.is_in_group("Fireball") or area.is_in_group("Ice") or area.is_in_group("Earth") and !broken:
		broken = true
		$Area2D/CollisionShape2D.call_deferred('free')
		var rng := RandomNumberGenerator.new()
		rng.randomize()
		var opalamount : int = rng.randi_range(MIN,MAX)
		emit_signal("give_opals", opalamount)
		$AnimationPlayer.play("Break")

