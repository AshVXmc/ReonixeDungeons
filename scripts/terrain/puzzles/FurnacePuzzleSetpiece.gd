extends Node2D

var is_on : bool = true

onready var tilemap = get_parent()
onready var furnace_cell_pos = tilemap.world_to_map(self.position)
onready var furnace_cell_current_id = tilemap.get_cellv(furnace_cell_pos) 
# this works. 


func _on_Area2D_area_entered(area):
	if area.is_in_group("Player"):
		turn_furnace_off()


func turn_furnace_off():
	is_on = false
	$Light2D.visible = false
	tilemap.set_cellv(furnace_cell_pos, 10 + 1)
	$PuzzlePipesFurnaceBurningParticles.emitting = false
