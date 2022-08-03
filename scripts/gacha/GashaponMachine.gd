class_name GashaponMachine extends Node2D

onready var player = get_parent().get_node("Player").get_node("Area2D")
var prize_pool : Dictionary = {}

func _ready():
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
	var loot1 : String
	var loot1amount : int
	# 3 star types (common, uncommon, rare etc)
	var loot_type_rng = RandomNumberGenerator.new()
	loot_type_rng.randomize()
	var loot_type = loot_type_rng.randi_range(1,100)
	if loot_type <= 50:
		var threestarcommonloot = prize_pool["3*common"]
		loot1 = threestarcommonloot[randi() % threestarcommonloot.size()]
		var loot_amount_rng = RandomNumberGenerator.new()
		loot_amount_rng.randomize()
		loot1amount = loot_amount_rng.randi_range(10, 25)
	elif loot_type >= 51 and loot_type <= 80:
		var threestaruncommonloot = prize_pool["3*uncommon"]
		loot1 = threestaruncommonloot[randi() % threestaruncommonloot.size()]
		var loot_amount_rng = RandomNumberGenerator.new()
		loot_amount_rng.randomize()
		loot1amount = loot_amount_rng.randi_range(1,4)
	else:
		var threestarrareloot = prize_pool["3*rare"]
		loot1 = threestarrareloot[randi() % threestarrareloot.size()]
		var loot_amount_rng = RandomNumberGenerator.new()
		loot_amount_rng.randomize()
		loot1amount = loot_amount_rng.randi_range(1,3)
	
	# Calculate loot for three-star items
#	var threestarloot = prize_pool["3*"]
#	var loot1 = threestarloot[randi() % threestarloot.size()]
#	var loot1amount = int(loot1)
	

	
	
	# Calculate loot for opals
	var lootopals = "Opals"
	var opalrng : RandomNumberGenerator = RandomNumberGenerator.new()
	opalrng.randomize()
	var lootopalsamount = opalrng.randi_range(10, 50)

	
	
	var FINAL_LOOT = [loot1, loot1amount, lootopals, lootopalsamount]
	print(FINAL_LOOT)
	for loot in FINAL_LOOT:
		print(loot)
			
	
func _on_RollOne_pressed():
	roll_single()
