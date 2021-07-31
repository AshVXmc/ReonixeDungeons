extends StaticBody2D

const TYPE : String = "DestructableWall"
var durability : int = 2

func _ready():
	$AnimatedSprite.playing = true

func damage():
	durability -= 1
	match durability:
		2: 
			$AnimatedSprite.play("dur2")
		1:
			$AnimatedSprite.play("dur1")
		0:
			queue_free()

func _on_Area2D_area_entered(area):
	if area.is_in_group("Sword") or area.is_in_group("Fireball") and durability > 0:
		damage()
