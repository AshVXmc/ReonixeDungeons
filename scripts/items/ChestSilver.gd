class_name SilverChest extends Node2D

export var chestID : int
export var opals : int
export var locked : bool = false
var hasbeenopened : bool = false
onready var AREA : Area2D = $Area2D
onready var PLAYER : Area2D = get_parent().get_node("Player").get_node("Area2D")
const OPENED_PARTICLES = preload("res://scenes/particles/ChestParticle.tscn")
const OPENED_TEXTURE : StreamTexture = preload("res://assets/chests/chest_silver_open.png")
const CLOSED_TEXTURE : StreamTexture = preload("res://assets/chests/chest_silver_closed.png")
var LOCKED_TEXTURE : StreamTexture 

signal give_opals(amount)
signal autosave()
func _ready():
	connect("give_opals", get_parent().get_node("Player"), "get_opals")
	if locked:
		LOCKED_TEXTURE = load("res://assets/chests/chest_silver_closed_locked.png")
	
	if !Global.opened_chests.has(chestID):
		connect("autosave", get_parent().get_node("PauseUI/Pause") , "_on_SaveButton_pressed")
		hasbeenopened = false
		if locked:
			$Sprite.texture = LOCKED_TEXTURE
		else:
			$Sprite.texture = CLOSED_TEXTURE
	else:
		hasbeenopened = true
		$Sprite.texture = OPENED_TEXTURE
	$Label.visible = false

func _process(_delta):
	if !locked and AREA.overlaps_area(PLAYER) and Input.is_action_just_pressed("ui_use") and !Global.opened_chests.has(chestID) and !hasbeenopened:
		Global.opened_chests.append(chestID)
		emit_signal("give_opals", opals)
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



# when all associated enemies are defeated, unlocks this chest.
# Enemies that are required to be defeated are marked with "Chest<ID>Enemy"
func unlock():
	pass
	

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Unlock":
		locked = false
		$Sprite.texture = CLOSED_TEXTURE
