extends Node2D

export(int) var fire_height_in_tiles = 4

func _ready():
	setup_fire()

func setup_fire():
	$StaticBody2D/CollisionShape2D.position.x = 0
	$StaticBody2D/CollisionShape2D.position.y = 10 * fire_height_in_tiles
	$StaticBody2D/CollisionShape2D.shape.extents.x = 8
	$StaticBody2D/CollisionShape2D.shape.extents.y = 10 * fire_height_in_tiles
	
	# 4 tiles: pos y 40.5, scale y 1.444
	# 3 tiles: pos y 30.5, scale y 1.069
	# 2 tiles: pos y 20.5, scale y 0.708
	# scale y / pos y = 35. roughly. 
	$Light2D.position = Vector2(0, 10 * fire_height_in_tiles)
	$Light2D.scale = Vector2(0.5, (10 * fire_height_in_tiles) * 0.035)
	
	# 4 tiles: lifetime 2.4
	# 3 tiles: lifetime 2.2
	# 2 tiles: lifetime 1.8
	# 1 tile: lifetime 1.2
	$PuzzlePipesFurnaceBurningParticles.lifetime = 0.4 * fire_height_in_tiles + 0.85
	# turn it on
	$PuzzlePipesFurnaceBurningParticles.emitting = true

func turn_off_fire():
	$PuzzlePipesFurnaceBurningParticles.emitting = false
	$StaticBody2D/CollisionShape2D.disabled = true
