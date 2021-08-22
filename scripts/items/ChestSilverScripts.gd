extends AnimatedSprite

export var chestID : String
export var LOOT : PackedScene = preload("res://scenes/items/HealthPot.tscn")
var loot = LOOT.instance()
var hasbeenopened = false

func _ready():
	print(Global.unopened_chests)
	chestID =  get_tree().current_scene.name + "_chest"

func _process(_delta):
	if Global.unopened_chests.has(chestID):
		$AnimatedSprite.play("Idle")
	if hasbeenopened:
		$AnimatedSprite.play("Opened")

func _on_Area2D_area_entered(area):
	if area.is_in_group("Player"):
		if Global.unopened_chests.has(chestID) and !hasbeenopened:
			print(Global.unopened_chests)
			Global.unopened_chests.erase(chestID)
			get_parent().add_child(loot)
			loot.position = $Position2D.global_position
			hasbeenopened = true
			$Area2D/CollisionShape2D.queue_free()
