class_name SilverChest extends Node2D

# assign a unique integer ID for every chest in the game. Start with 1
export var chestID : int = -1 # value is -1 if invalid.
export var opals : int

var hasbeenopened : bool = false
onready var AREA : Area2D = $Area2D
onready var PLAYER : Area2D = get_parent().get_node("Player").get_node("Area2D")
const OPENED_PARTICLES = preload("res://scenes/particles/ChestParticle.tscn")
const OPENED_TEXTURE : StreamTexture = preload("res://assets/chests/chest_silver_open.png")
const CLOSED_TEXTURE : StreamTexture = preload("res://assets/chests/chest_silver_closed.png")

# used by locked chests only.
var LOCKED_TEXTURE : StreamTexture 

# used by key-locked chests only.
var key : ChestKey 


# LS is short for 'lock status'
enum LS {
	UNLOCKED,
	LOCKED_BY_KEY,
	LOCKED_BY_ENEMY,
}

export (LS) var lock_status = LS.UNLOCKED

signal give_opals(amount)
signal autosave()
func _ready():
	connect("give_opals", get_parent().get_node("Player"), "get_opals")
	if lock_status != LS.UNLOCKED:
		LOCKED_TEXTURE = load("res://assets/chests/chest_silver_closed_locked.png")
	
	if !Global.opened_chests.has(chestID):
		connect("autosave", get_parent().get_node("PauseUI/Pause") , "_on_SaveButton_pressed")
		hasbeenopened = false
		if lock_status != LS.UNLOCKED:
			$Sprite.texture = LOCKED_TEXTURE
			if lock_status == LS.LOCKED_BY_KEY:
				pass
			
		else:
			$Sprite.texture = CLOSED_TEXTURE
			
	else:
		hasbeenopened = true
		$Sprite.texture = OPENED_TEXTURE
	
	$Label.visible = false

func _process(_delta):
	if lock_status == LS.UNLOCKED and AREA.overlaps_area(PLAYER) and Input.is_action_just_pressed("ui_use") and !Global.opened_chests.has(chestID) and !hasbeenopened:
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
		lock_status = LS.UNLOCKED
		$Sprite.texture = CLOSED_TEXTURE
