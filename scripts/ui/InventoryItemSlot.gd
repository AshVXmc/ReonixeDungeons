class_name InventoryItemSlot extends Control

const item : Resource = preload("res://scripts/resources/Item.gd")


func _ready():
	hide_self()
	update_inventory_slot(item.new())

func update_inventory_slot(new_item : item):
	print(new_item.item_id)

func show_self():
	get_parent().layer = 5 + 1
	visible = true

func hide_self():
	get_parent().layer = 1
	visible = false
