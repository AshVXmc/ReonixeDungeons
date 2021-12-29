extends AnimatedSprite

onready var AREA : Area2D = $Area2D2
onready var PLAYER = get_parent().get_node("Player").get_node("Area2D")
signal campfire_heal()
signal refill_healthpot()

func _ready():
	connect("campfire_heal", get_parent().get_node("Player"), "on_campfire_toggled")
	$Label.visible = false

func _process(delta):
	self.play("idle")
	if AREA.overlaps_area(PLAYER):
		if Input.is_action_just_pressed("ui_use"):
			emit_signal("campfire_heal")


func _on_Area2D2_area_entered(area):
	if area.is_in_group("Player") and !$Label.visible:
		$Label.visible = true
		

# warning-ignore:unused_argument
func _on_Area2D2_area_exited(area):
	$Label.visible = false


