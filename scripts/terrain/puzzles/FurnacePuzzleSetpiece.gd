extends Node2D

var is_on : bool = true

onready var tilemap = get_parent()
onready var furnace_cell_pos = tilemap.world_to_map(self.position)
onready var furnace_cell_current_id = tilemap.get_cellv(furnace_cell_pos) 
export (String) var furnace_puzzle_fire_setpiece_name 
export (Array, Vector2) var puzzle_pipe_tile_coordinates
enum TILE_ID {
	INACTIVE_TOP_EXHAUST ,
	INACTIVE_VERTICAL,
	INACTIVE_HORIZONTAL,
	INACTIVE_ELBOW_TOP_TO_RIGHT,
	INACTIVE_ELBOW_BOTTOM_TO_RIGHT,
	INACTIVE_ELBOW_BOTTOM_TO_LEFT,
	INACTIVE_ELBOW_TOP_TO_LEFT,
	INACTIVE_BOTTOM_EXHAUST,
	INACTIVE_RIGHT_EXHAUST,
	INACTIVE_LEFT_EXHAUST,
	FURNACE_ON,
	FURNACE_OFF,
	ACTIVE_TOP_EXHAUST ,
	ACTIVE_VERTICAL,
	ACTIVE_HORIZONTAL,
	ACTIVE_ELBOW_TOP_TO_RIGHT,
	ACTIVE_ELBOW_BOTTOM_TO_RIGHT,
	ACTIVE_ELBOW_BOTTOM_TO_LEFT,
	ACTIVE_ELBOW_TOP_TO_LEFT,
	ACTIVE_BOTTOM_EXHAUST,
	ACTIVE_RIGHT_EXHAUST,
	ACTIVE_LEFT_EXHAUST,
}
# NOTE : left mouse click on a puzzle pipe tile to print its coordinates (PuzzlePipesTileMap.gd)


func _on_Area2D_area_entered(area):
	if area.is_in_group("Player"):
		turn_furnace_off()


func turn_furnace_off():
	is_on = false
	$Light2D.visible = false
	tilemap.set_cellv(furnace_cell_pos, 10 + 1)
	$PuzzlePipesFurnaceBurningParticles.emitting = false
	
	if furnace_puzzle_fire_setpiece_name != null:
		get_parent().get_node(furnace_puzzle_fire_setpiece_name).turn_off_fire()
	turn_active_pipes_off()

func turn_active_pipes_off():
	for pipe_tile_coordinate in puzzle_pipe_tile_coordinates:
		var tile_id : int = tilemap.get_cellv(pipe_tile_coordinate)
		match tile_id:
			TILE_ID.ACTIVE_TOP_EXHAUST:
				tilemap.set_cellv(pipe_tile_coordinate, TILE_ID.INACTIVE_TOP_EXHAUST)
			TILE_ID.ACTIVE_VERTICAL:
				tilemap.set_cellv(pipe_tile_coordinate, TILE_ID.INACTIVE_VERTICAL)
			TILE_ID.ACTIVE_HORIZONTAL:
				tilemap.set_cellv(pipe_tile_coordinate, TILE_ID.INACTIVE_HORIZONTAL)
			TILE_ID.ACTIVE_ELBOW_TOP_TO_RIGHT:
				tilemap.set_cellv(pipe_tile_coordinate, TILE_ID.INACTIVE_ELBOW_TOP_TO_RIGHT)
			TILE_ID.ACTIVE_ELBOW_BOTTOM_TO_RIGHT:
				tilemap.set_cellv(pipe_tile_coordinate, TILE_ID.INACTIVE_ELBOW_BOTTOM_TO_RIGHT)
			TILE_ID.ACTIVE_ELBOW_BOTTOM_TO_LEFT:
				tilemap.set_cellv(pipe_tile_coordinate, TILE_ID.INACTIVE_ELBOW_BOTTOM_TO_LEFT)
			TILE_ID.ACTIVE_ELBOW_TOP_TO_LEFT:
				tilemap.set_cellv(pipe_tile_coordinate, TILE_ID.INACTIVE_ELBOW_TOP_TO_LEFT)
			TILE_ID.ACTIVE_BOTTOM_EXHAUST:
				tilemap.set_cellv(pipe_tile_coordinate, TILE_ID.INACTIVE_BOTTOM_EXHAUST)
			TILE_ID.ACTIVE_RIGHT_EXHAUST:
				tilemap.set_cellv(pipe_tile_coordinate, TILE_ID.INACTIVE_RIGHT_EXHAUST)
			TILE_ID.ACTIVE_LEFT_EXHAUST:
				tilemap.set_cellv(pipe_tile_coordinate, TILE_ID.INACTIVE_LEFT_EXHAUST)
			


