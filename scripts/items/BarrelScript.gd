extends AnimatedSprite

var broken : bool = false
export var MAX : int = 5
export var MIN : int = 1
signal give_opals(opals)

func _ready():
	connect("give_opals", get_parent().get_node("Player"), "get_opals")

func _process(_delta):
	if !broken:
		self.play("Idle")
	
func _on_Area2D_area_entered(area):
	if area.is_in_group("Sword") or area.is_in_group("Fireball") and !broken:
		broken = true
		self.play("Break")
		$Area2D/CollisionShape2D.queue_free()
		
		var rng := RandomNumberGenerator.new()
		rng.randomize()
		var opalamount : int = rng.randi_range(MIN,MAX)
		emit_signal("give_opals", opalamount)
		
		
