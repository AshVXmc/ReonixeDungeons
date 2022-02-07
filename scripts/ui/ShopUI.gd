extends Control

signal item_bought(item_name, item_price)
var heart : String = "[img=32]res://assets/UI/heart.png[/img]"
var mana : String = "[img=32]res://assets/UI/mana.png[/img]"

func _ready():
	connect("item_bought", get_parent().get_parent().get_parent().get_node("Player"), "on_Item_bought")
	var rng : RandomNumberGenerator = RandomNumberGenerator.new()
	rng.randomize()
	var num : int = rng.randi_range(0,3)
	match num:
		0:
			$FlavorText.bbcode_text = "What are ya buyin'? Yes, that is a pop-culture reference."
		1:
			$FlavorText.bbcode_text = "I have several items that might spark your intrest."
		2:
			$FlavorText.bbcode_text = "Consider all of your purchases an investment."
		3:
			$FlavorText.bbcode_text = "Shop more. Live longer. That's my motto."



func _process(delta):
	pass
#	if Input.is_action_just_pressed("ui_use"):
#		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
#		self.visible = true
	
func _on_HealthPotButton_pressed():
#	print("code worked")
	if Global.opals_amount >= 10:
		emit_signal("item_bought", "HealthPot", 10)
		
func _on_HealthPotButton_mouse_entered():
	$FlavorText.bbcode_text = "A flask filled with hearty red liquid, tastes like sweetened lemon juice. Heals for 1" + heart + ", and takes one second to consume."


func _on_HealthPotButton_mouse_exited():
	$FlavorText.bbcode_text = ""



#func _on_Exit_pressed():
#	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
#	get_tree().paused = false
#	self.visible = false

