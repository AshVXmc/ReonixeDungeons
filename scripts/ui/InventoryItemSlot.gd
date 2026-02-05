class_name InventoryItemSlot extends Control

const item = preload("res://scripts/resources/Item.gd")
var contained_item : Item

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
	$ItemCountLabel.text = ""

func register_contained_item(new_item : Item):
	contained_item = new_item
	$ItemTextureRect.texture = load(new_item.item_texture_path)
	$ItemCountLabel.text = str(new_item.item_count)
	
func increment_item_count(added_value : int):
	if contained_item == null:
		return
	contained_item.item_count += added_value

func decrement_item_count(reduced_value : int):
	if contained_item == null:
		return
	contained_item.item_count -= reduced_value


