extends Control

signal item_bought(item_name, item_price)
var heart : String = "[img=32]res://assets/UI/heart.png[/img]"
var mana : String = "[img=32]res://assets/UI/mana.png[/img]"
var maxstorage : String = str(Global.max_item_storage)

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

func _on_Exit_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	get_parent().get_parent().queue_free()


func _process(delta):
	pass
#	if Input.is_action_just_pressed("ui_use"):
#		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
#		self.visible = true
	
func _on_HealthPotButton_pressed():
	if Global.opals_amount >= 20:
		if Global.healthpot_amount == Global.max_item_storage:
			$FlavorText.bbcode_text = "You can't hold more than " + maxstorage + " of this"
		else:
			$FlavorText.bbcode_text = "Thank you for your purchase."
			emit_signal("item_bought", "HealthPot", 20)
		
func _on_HealthPotButton_mouse_entered():
	$FlavorText.bbcode_text = "A flask filled with hearty red liquid, tastes like... blood?. Heals for 1" + heart + ", and takes one second to consume. You can hold " + maxstorage + " of this at a time." 

func _on_HealthPotButton_mouse_exited():
	$FlavorText.bbcode_text = ""

func _on_ManaPotButton_pressed():
	if Global.opals_amount >= 20:
		if Global.manapot_amount == Global.max_item_storage:
			$FlavorText.bbcode_text = "You can't hold more than " + maxstorage + " of this"
		else:
			$FlavorText.bbcode_text = "Thank you for your purchase."
			emit_signal("item_bought", "ManaPot", 20)

func _on_ManaPotButton_mouse_entered():
	$FlavorText.bbcode_text = "Magical, glowing and swirling blue liquid that restores your Mana" + mana + "to full. Takes two seconds to consume. You can hold " + maxstorage + " of this at a time."

func _on_ManaPotButton_mouse_exited():
	$FlavorText.bbcode_text = ""

func _on_LifeWineButton_pressed():
	if Global.opals_amount >= 45:
		if Global.healthpot_amount == Global.max_item_storage:
			$FlavorText.bbcode_text = "You can't hold more than " + maxstorage + " of this"
		else:
			$FlavorText.bbcode_text = "Thank you for your purchase."
			emit_signal("item_bought", "HealthPot", 20)

func _on_LifeWineButton_mouse_entered():
	$FlavorText.bbcode_text = "High-quality red wine with a thick bouquet, and restores your" + heart + "to full. Takes 2.5 seconds to consume. You can hold " + maxstorage + "of this at a time."

func _on_LifeWineButton_mouse_exited():
	$FlavorText.bbcode_text = ""

# Item storage levels: 3, 5, 8

func _on_ItemPouchButton_pressed():
	if Global.opals_amount >= 100 and $ItemPouch/SpriteLabel.text == "I":
		Global.max_item_storage = 5


func _on_ItemPouchButton_mouse_entered():
	pass # Replace with function body.


func _on_ItemPouchButton_mouse_exited():
	pass # Replace with function body.
