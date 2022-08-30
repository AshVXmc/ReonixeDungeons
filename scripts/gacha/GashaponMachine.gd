class_name GashaponMachine extends Node2D

onready var player = get_parent().get_node("Player").get_node("Area2D")
var prize_pool : Dictionary = {}

func _ready():
	$CanvasLayer/Control.visible = false
	# Read and parse JSON file which contains prize pool data.
	var file : File = File.new()
	file.open("res://scenes/gacha/PrizePool.json", file.READ)
	prize_pool = parse_json(file.get_as_text())
	$Label.visible = false
	$Keybind.visible = false

func _on_Detector_area_entered(area):
	if area.is_in_group("Player") and !$Label.visible:
		$Label.visible = true
		$Keybind.visible = true

func _process(delta):
	if $Detector.overlaps_area(player):
		if Input.is_action_just_pressed("ui_use"):
			$CanvasLayer/Control.visible = true
func _on_Detector_area_exited(area):
	if area.is_in_group("Player") and $Label.visible:
		$Label.visible = false
		$Keybind.visible = false


func _on_CloseButton_pressed():
	$CanvasLayer/Control.visible = false

func roll_single():
	var loot : String
	var lootamount : int
	var loot_type_rng = RandomNumberGenerator.new()
	loot_type_rng.randomize()
	var loot_type = loot_type_rng.randi_range(1,100)
	# Three stars
	if loot_type <= 90:
#		var threestarcommonloot = prize_pool["3*common"]
		loot = prize_pool["3*common"][randi() % prize_pool["3*common"].size()]
		
		return loot
		
		
	elif loot_type > 90 and loot_type <= 98:
		return "4STAR"
	elif loot_type > 98:
		return "5STAR"

	
			
	
func _on_RollOne_pressed():
	var LOOT : Array = [roll_single(), roll_single(), roll_single()]
	print(LOOT)

