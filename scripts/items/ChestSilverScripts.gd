extends Node2D

export var chestID : String
export var LOOT : PackedScene = preload("res://scenes/items/LootBag.tscn")
var loot = LOOT.instance()
var hasbeenopened = false
onready var AREA : Area2D = $Area2D
onready var PLAYER = get_parent().get_node("Player").get_node("Area2D")

func _ready():
#	Debug
#	print(Global.unopened_chests)

	chestID =  get_tree().current_scene.name + "_chest"
	$Label.visible = false

func _process(_delta):
	if Global.unopened_chests.has(chestID):
		$AnimatedSprite.play("Idle")
	if hasbeenopened:
		$AnimatedSprite.play("Opened")
	if AREA.overlaps_area(PLAYER) and Input.is_action_just_pressed("ui_use") and Global.unopened_chests.has(chestID) and !hasbeenopened:
		print(Global.unopened_chests)
		Global.unopened_chests.erase(chestID)
		get_parent().add_child(loot)
		loot.position = $Position2D.global_position
		hasbeenopened = true
		$Area2D/CollisionShape2D.queue_free()


func _on_Area2D_area_entered(area):
	if area.is_in_group("Player") and !$Label.visible:
		$Label.visible = true

func _on_Area2D_area_exited(area):
	$Label.visible = false
