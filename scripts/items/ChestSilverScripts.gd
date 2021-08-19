extends AnimatedSprite

const chestID : String = "Level1_chest"
const LOOT : PackedScene = preload("res://scenes/items/HealthPot.tscn")
var loot = LOOT.instance()

func _process(delta):
	if Global.unopened_chests.has(chestID):
		$AnimatedSprite.play("Idle")
	else:
		$AnimatedSprite.play("Opened")	

func _on_Area2D_area_entered(area):
	if area.is_in_group("Player") and Global.unopened_chests.has(chestID):
		# Mark as opened
		Global.mark_opened(chestID)
		
		$AnimatedSprite.play("Opened")
		get_parent().add_child(loot)
		loot.position = $Position2D.global_position
		$Area2D/CollisionShape2D.queue_free()
		
		
	
