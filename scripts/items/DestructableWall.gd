extends StaticBody2D

const TYPE : String = "DestructableWall"
const cracked1 = preload("res://assets/terrain/brick_terrain_cracked.png")
const cracked2 = preload("res://assets/terrain/brick_terrain_cracked2.png")
var durability : int = 2

func _ready():
	$Sprite.texture = cracked1

func damage():
	durability -= 1
	if durability == 0:
		queue_free()
	else:
		$Sprite.texture = cracked2
	
func _on_Area2D_area_entered(area):
	if area.is_in_group("Sword") or area.is_in_group("Fireball") and durability > 0:
		damage()
