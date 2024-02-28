class_name SilverChest extends Node2D

export var chestID : int
export var Opals : int
var hasbeenopened = false
onready var AREA : Area2D = $Area2D
onready var PLAYER = get_parent().get_node("Player").get_node("Area2D")
const OPENED_PARTICLES = preload("res://scenes/particles/ChestParticle.tscn")
const OPENED_TEXTURE = preload("res://assets/chests/chest_silver_open.png")
const CLOSED_TEXTURE = preload("res://assets/chests/chest_silver_closed.png")
signal give_opals(amount)
signal autosave()
func _ready():
	connect("give_opals", get_parent().get_node("Player"), "get_opals")
	if !Global.opened_chests.has(chestID):
		connect("autosave", get_parent().get_node("PauseUI/Pause") , "_on_SaveButton_pressed")
		hasbeenopened = false
		$Sprite.texture = CLOSED_TEXTURE
	else:
		hasbeenopened = true
		$Sprite.texture = OPENED_TEXTURE
	$Label.visible = false

func _process(_delta):
	if AREA.overlaps_area(PLAYER) and Input.is_action_just_pressed("ui_use") and !Global.opened_chests.has(chestID) and !hasbeenopened:
		Global.opened_chests.append(chestID)
		emit_signal("give_opals", Opals)
		# Particles that show up when the chest is opened
		var opened_particles = OPENED_PARTICLES.instance()
		get_parent().add_child(opened_particles)
		opened_particles.position = global_position
		opened_particles.emitting = true
		opened_particles.one_shot = true
		$Sprite.texture = OPENED_TEXTURE
		emit_signal("autosave")
		
func _on_Area2D_area_entered(area):
	if area.is_in_group("Player") and !$Label.visible and !Global.opened_chests.has(chestID):
		$Label.visible = true

func _on_Area2D_area_exited(area):
	$Label.visible = false
