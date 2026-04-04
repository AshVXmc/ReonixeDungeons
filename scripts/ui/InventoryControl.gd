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
	add_item_to_inventory(item.new(item.ID.HEALTH_POTION), 2)
	add_item_to_inventory(item.new(item.ID.LARGE_HEALTH_POTION), 1)
	
	
func _process(delta):
	if !visible:
		if Input.is_action_just_pressed("ui_toggle_inventory") and Global.game_paused_by == "":
			open_menu()
	else:
		if Input.is_action_just_pressed("ui_toggle_inventory") or Input.is_action_just_pressed("ui_cancel"):
			close_menu()

# usually called at game init
func update_inventory_ui():
	for item_category in Global.current_player_inventory:
		for item_slot in Global.current_player_inventory[item_category]:
			pass
	
func add_item_to_inventory(obtained_item : item, amount : int):
	var item_category : String = ""
	var slot_index : int = -1
	var is_new_item : bool = true
	match obtained_item.get_category():
		item.CATEGORY.POTIONS:
			item_category = "PotionsCategory"
	
	for item_slot in Global.current_player_inventory[item_category]:
		if Global.current_player_inventory[item_category][item_slot]["ContainedItem"] == null:
			Global.current_player_inventory[item_category][item_slot]["ContainedItem"] = obtained_item
			Global.current_player_inventory[item_category][item_slot]["ContainedItemAmount"] += amount
			slot_index = int(item_slot.substr(4))
			is_new_item = false
			break
		elif Global.current_player_inventory[item_category][item_slot]["ContainedItem"].get_id() == obtained_item.get_id():
			Global.current_player_inventory[item_category][item_slot]["ContainedItemAmount"] += amount
			slot_index = int(item_slot.substr(4))
			is_new_item = true
			break
		
	# update inventory slot ui
	var slot_control : InventoryItemSlot = inventory_grid_container.get_node("InventoryItemSlotCanvasLayer" + str(slot_index) + "/Control")
	slot_control.register_contained_item(obtained_item)
	slot_control.increment_item_count(amount)
	

	# debug, print inventory contents
	print("ADDED NEW ITEM: " + str(amount) + " " + obtained_item.get_name())
	print("CURRENT INVENTORY: ")
	for i in Global.current_player_inventory["PotionsCategory"]:
		if Global.current_player_inventory["PotionsCategory"][i]["ContainedItem"] == null:
			print(i + " null")
		else:
			print(i + " " + str(Global.current_player_inventory["PotionsCategory"][i]["ContainedItemAmount"]) + " " + Global.current_player_inventory["PotionsCategory"][i]["ContainedItem"].get_name())

# assumes the item exists in the inventory, with a quantity > 0
func remove_item_from_inventory(removed_item : item, amount : int):
	var item_category : String
	match removed_item.get_category():
		item.CATEGORY.POTIONS:
			item_category = "PotionsCategory"
	
	for item_slot in Global.current_player_inventory[item_category]:
		if Global.current_player_inventory[item_category][item_slot]["ContainedItem"].get_id() == removed_item.get_id():
			pass

func item_exists_in_inventory(item : item) -> bool:
	return true


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
