extends Area2D



func _on_FireDetector1_area_entered(area):
	if area.is_in_group("Fireball"):
		var tilemap : TileMap = get_parent()
		var cell : Vector2 = tilemap.world_to_map(global_position)
		var tile_id : int = tilemap.get_cellv(cell)
		if tile_id == 0:
			tilemap.set_cellv(cell, 1)
		if tile_id == 1:
			tilemap.set_cellv(cell, -1)
			call_deferred('free')
