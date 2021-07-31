extends StaticBody2D

var broken : bool = false
const LOOT : PackedScene = preload("res://scenes/items/HealthPot.tscn")
const MAX : int = 4
const MIN : int = 1


func _process(_delta):
	if !broken:
		$AnimatedSprite.play("Idle")
	
func _on_Area2D_area_entered(area):
	if area.is_in_group("Sword") or area.is_in_group("Fireball") and !broken:
		broken = true
		$AnimatedSprite.play("Break")
		$Area2D/CollisionShape2D.queue_free()
		$CollisionShape2D_rigid.queue_free()
		
		var loot = LOOT.instance()
		var lootrng : RandomNumberGenerator = RandomNumberGenerator.new()
		lootrng.randomize()
		var randomint = lootrng.randi_range(MIN,MAX)
		print(randomint)

		if randomint == MIN:
			get_parent().add_child(loot)
			loot.position = $Position2D.global_position

