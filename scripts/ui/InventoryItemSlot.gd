class_name InventoryItemSlot extends Control

const item = preload("res://scripts/resources/Item.gd")
var contained_item : Item
var item_count : int = 0

func _ready():
	hide_self()

func show_self():
	get_parent().layer = 5 + 1
	visible = true

func hide_self():
	get_parent().layer = 1
	visible = false




func clear_contained_item():
	contained_item = null
	$ItemTextureRect.texture = null
	item_count = 0
	$ItemCountLabel.text = ""

func register_contained_item(new_item : Item):
	contained_item = new_item
	$ItemTextureRect.texture = load(new_item.item_texture_path)

func increment_item_count(added_value : int):
	if contained_item == null:
		return
	item_count += added_value
	$ItemCountLabel.text = str(item_count)

func decrement_item_count(reduced_value : int):
	if contained_item == null:
		return
	item_count -= reduced_value
	$ItemCountLabel.text = str(item_count)


