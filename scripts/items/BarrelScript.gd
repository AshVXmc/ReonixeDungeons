extends AnimatedSprite

var broken : bool = false
const LOOT : PackedScene = preload("res://scenes/items/LootBag.tscn")
export var MAX : int = 5
export var MIN : int = 1


func _process(_delta):
	if !broken:
		self.play("Idle")
	
func _on_Area2D_area_entered(area):
	if area.is_in_group("Sword") or area.is_in_group("Fireball") and !broken:
		broken = true
		self.play("Break")
		$Area2D/CollisionShape2D.queue_free()
		
#		var loot = LOOT.instance()
#		var lootrng : RandomNumberGenerator = RandomNumberGenerator.new()
#		lootrng.randomize()
#		var randomint = lootrng.randi_range(MIN,MAX)
#		if randomint == MIN:
#			get_parent().add_child(loot)
#			loot.position = $Position2D.global_position
