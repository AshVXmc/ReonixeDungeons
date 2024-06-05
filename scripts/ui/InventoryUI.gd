class_name InventoryUI extends Control

onready var closed = preload("res://assets/misc/item_pouch.png")
onready var opened = preload("res://assets/misc/item_pouch_opened.png")


func _ready():
	visible = false
	get_parent().get_node("Bag/BagSprite").texture = closed
	$CommonMonsterDust/Label.text = str(Global.drops_inventory["common_dust"])
	$GoblinScales/Label.text = str(Global.drops_inventory["goblin_scales"])
	$BatWings/Label.text = str(Global.drops_inventory["bat_wings"])
	$SweetHerbs/Label.text = str(Global.drops_inventory["sweet_herbs"])
	
func _physics_process(delta):
	if Input.is_action_just_pressed("ui_toggle_inventory"):
		if !visible:
			visible = true
			get_parent().get_node("Bag/BagSprite").texture = opened
		else:
			visible = false
			get_parent().get_node("Bag/BagSprite").texture = closed

func on_ingredient_obtained(ingr_name : String, amount : int):
	match ingr_name:
		"common_dust":
			if Global.drops_inventory["common_dust"] == 0:
				$CommonMonsterDust/TextureRect.visible = false
				$CommonMonsterDust/Label.visible = false
			else:
				$CommonMonsterDust/TextureRect.visible = true
				$CommonMonsterDust/Label.visible = true
			$CommonMonsterDust/Label.text = str(Global.drops_inventory["common_dust"])
		"goblin_scales":
			if Global.drops_inventory["goblin_scales"] == 0:
				$GoblinScales/TextureRect.visible = false
				$GoblinScales/Label.visible = false
			else:
				$GoblinScales/TextureRect.visible = true
				$GoblinScales/Label.visible = true
			$GoblinScales/Label.text = str(Global.drops_inventory["goblin_scales"])
		"bat_wings":
			if Global.drops_inventory["bat_wings"] == 0:
				$BatWings/TextureRect.visible = false
				$BatWings/Label.visible = false
			else:
				$BatWings/TextureRect.visible = true
				$BatWings/Label.visible = true
			$BatWings/Label.text = str(Global.drops_inventory["bat_wings"])
		"sweet_herbs":
			if Global.drops_inventory["sweet_herbs"] == 0:
				$SweetHerbs/TextureRect.visible = false
				$SweetHerbs/Label.visible = false
			else:
				$SweetHerbs/TextureRect.visible = true
				$SweetHerbs/Label.visible = true
			$SweetHerbs/Label.text = str(Global.drops_inventory["sweet_herbs"])
