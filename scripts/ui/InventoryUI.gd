class_name InventoryUI extends Control

onready var closed = preload("res://assets/misc/item_pouch.png")
onready var opened = preload("res://assets/misc/item_pouch_opened.png")


func _ready():
	visible = false
	get_parent().get_node("BagSprite").texture = closed
func _physics_process(delta):
	if Input.is_action_just_pressed("ui_toggle_inventory"):
		if !visible:
			visible = true
			get_parent().get_node("BagSprite").texture = opened
		else:
			visible = false
			get_parent().get_node("BagSprite").texture = closed
func on_ingredient_obtained(ingr_name : String, amount : int):
	match ingr_name:
		"common_dust":
			if Global.common_monster_dust_amount == 0:
				$CommonMonsterDust/TextureRect.visible = false
				$CommonMonsterDust/Label.visible = false
			else:
				$CommonMonsterDust/TextureRect.visible = true
				$CommonMonsterDust/Label.visible = true
			$CommonMonsterDust/Label.text = str(Global.common_monster_dust_amount)
		"goblin_scales":
			if Global.goblin_scales_amount == 0:
				$GoblinScales/TextureRect.visible = false
				$GoblinScales/Label.visible = false
			else:
				$GoblinScales/TextureRect.visible = true
				$GoblinScales/Label.visible = true
			$GoblinScales/Label.text = str(Global.goblin_scales_amount)
