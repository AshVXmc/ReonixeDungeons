class_name Campfire extends AnimatedSprite

onready var AREA : Area2D = $Area2D2
onready var PLAYER = get_parent().get_node("Player").get_node("Area2D")
export var Activated : bool = false
signal campfire_heal()
signal refill_healthpot()

func _ready():
	$CanvasLayer/Control.visible = false
	connect("campfire_heal", get_parent().get_node("Player"), "on_campfire_toggled")
	$Label.visible = false
	$Keybind.visible = false
	$Keybind2.visible = false
	

func _process(delta):
	if Activated:
		play("idle")
		$SmokeParticles.visible = true
		$Light2D.visible = true
	else:
		play("off")
		$SmokeParticles.visible = false
		$Light2D.visible = false
	if AREA.overlaps_area(PLAYER):
		if Input.is_action_just_pressed("ui_use") and Activated and !$CanvasLayer/Control.visible:
			emit_signal("campfire_heal")
		elif Input.is_action_just_pressed("customize_skill") and !$CanvasLayer/Control.visible:
			get_parent().get_node("Player").is_shopping = true
			get_parent().get_node("Player").is_invulnerable = true
			$CanvasLayer/Control.visible = true


func _on_Area2D2_area_entered(area):
	if area.is_in_group("Player") and !$Label.visible and Activated:
		$Label.visible = true
		$Keybind.visible = true
		$Keybind2.visible = true
	if area.is_in_group("Fireball"):
		Activated = true
		

# warning-ignore:unused_argument
func _on_Area2D2_area_exited(area):
	$Label.visible = false
	$Keybind.visible = false
	$Keybind2.visible = false




func _on_CloseButton_pressed():
	get_parent().get_node("Player").is_shopping = false
	get_parent().get_node("Player").is_invulnerable = false
	$CanvasLayer/Control.visible = false


func _on_PrimarySkillSelect_pressed():
	$CanvasLayer/PrimarySkill.visible = true


func _on_SecondarySkillSelect_pressed():
	pass

func _on_RangedSkillSelect_pressed():
	pass # Replace with function body.

func _on_PrimaryCloseButton_pressed():
	$CanvasLayer/PrimarySkill.visible = false






