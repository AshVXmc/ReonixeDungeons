extends TileMap


# debug, delete later
func _input(event):
	if event.is_action_pressed("left_mouse"):
		var mouse_pos = get_local_mouse_position()
		var cell_pos = world_to_map(mouse_pos)
		var cell_tile_id = get_cellv(cell_pos)

		print("Cell ID at " + str(cell_pos) + " is " + str(cell_tile_id))

