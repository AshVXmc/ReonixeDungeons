extends Control

signal item_bought(item_name, item_price)
var baseprice : int = 0

func _ready():
	connect("item_bought", get_parent().get_parent().get_parent().get_node("Player"), "on_Item_bought")
	self.visible = false

func _process(delta):
	if Input.is_action_just_pressed("ui_use"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		self.visible = true
	
func _on_HealthPotButton_pressed():
#	print("code worked")
	if Global.opals_amount >= baseprice:
		emit_signal("item_bought", "HealthPot", baseprice)
		

func _on_Exit_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	get_tree().paused = false
	self.visible = false
