class_name InventoryUI extends Control

onready var closed = preload("res://assets/misc/item_pouch.png")
onready var opened = preload("res://assets/misc/item_pouch_opened.png")
onready var player : KinematicBody2D = get_parent().get_parent().get_node("Player")
onready var inventory_grid_container : GridContainer = $BelongingsControl/NinePatchRect/ScrollContainer/VBoxContainer/InventoryGridContainer

const item = preload("res://scripts/resources/Item.gd")

const MAX_INVENTORY_SLOTS : int = 5


func _ready():
	visible = false
	get_parent().get_node("InventoryIcon/BagSprite").texture = closed
	add_item_to_inventory(item.new(item.ID.HEALTH_POTION), 1)

func _process(delta):
	if !visible:
		if Input.is_action_just_pressed("ui_toggle_inventory") and Global.game_paused_by == "":
			open_menu()
	else:
		if Input.is_action_just_pressed("ui_toggle_inventory") or Input.is_action_just_pressed("ui_cancel"):
			close_menu()


func update_inventory_ui():
	pass
	
func add_item_to_inventory(obtained_item, amount : int):
	# case: item does not yet exist in the inventory (new time)
	print("ADDED NEW ITEM: " + str(amount) + " " + obtained_item.get_name())
	# TODO: sync ith inventoryitemslot? update the global dict first though

	

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
	Global.game_paused_by = "InventoryUI"
	visible = true
	
func close_menu():
	get_parent().layer = 1
	get_tree().paused = false
	hide_inventory_item_slots()
	Global.game_paused_by = ""
	visible = false
