extends Node2D


export (float) var energy_intensity = 0.65

func _ready():
	$Light2D.energy = energy_intensity
