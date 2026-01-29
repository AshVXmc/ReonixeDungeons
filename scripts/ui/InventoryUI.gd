class_name InventoryUI extends Control

onready var closed = preload("res://assets/misc/item_pouch.png")
onready var opened = preload("res://assets/misc/item_pouch_opened.png")
onready var player : KinematicBody2D = get_parent().get_parent().get_node("Player")
onready var inventory_grid_container : GridContainer = $BelongingsControl/NinePatchRect/ScrollContainer/VBoxContainer/InventoryGridContainer

func _ready():
	visible = false
	get_parent().get_node("Bag/BagSprite").texture = closed


func _process(delta):
	if Input.is_action_just_pressed("ui_toggle_inventory") and !player.is_shopping:
		if !visible:
			open_menu()
		else:
			close_menu()
	if Input.is_action_just_pressed("ui_cancel") and visible:
		close_menu()


func show_inventory_item_slots():
	for child in inventory_grid_container.get_children():
		child.get_node("Control").show_self()

func hide_inventory_item_slots():
	for child in inventory_grid_container.get_children():
		child.get_node("Control").hide_self()

func open_menu():
	get_parent().layer = 5
	get_tree().paused = true
	show_inventory_item_slots()
	visible = true
	
func close_menu():
	get_parent().layer = 1
	get_tree().paused = false
	hide_inventory_item_slots()
	visible = false
