class_name EleganceMeterUI extends Control

var elegance_rank
const max_elegance : int = 875


func _ready():
	print(Global.RANKS.C)

func _physics_process(delta):
	if Global.elegance_meter > max_elegance:
		Global.elegance_meter = max_elegance

