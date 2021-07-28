extends StaticBody2D

const TYPE : String = "DestructableWall"
var durability : int = 2

func _process(delta):
	$AnimatedSprite.play("dur2")
	
func damage():
	durability -= 1
	match durability:
		1:
			$AnimatedSprite.play("dur1")
		0:
			queue_free()

func _on_Area2D_area_entered(area):
	if area.is_in_group("Sword") or area.is_in_group("Fireball") and durability > 0:
		damage()
	
	if area.is_in_group("Player"):
		get_tree().change_scene("res://scenes/Level2.tscn")	
