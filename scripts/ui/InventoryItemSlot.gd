class_name InventoryItemSlot extends Control


func _ready():
	hide_self()

func show_self():
	get_parent().layer = 5 + 1
	visible = true

func hide_self():
	get_parent().layer = 1
	visible = false
