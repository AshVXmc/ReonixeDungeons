class_name InventoryUI extends Control

onready var closed = preload("res://assets/misc/item_pouch.png")
onready var opened = preload("res://assets/misc/item_pouch_opened.png")
onready var player : KinematicBody2D = get_parent().get_parent().get_node("Player")
onready var inventory_grid_container : GridContainer = $BelongingsControl/NinePatchRect/ScrollContainer/VBoxContainer/InventoryGridContainer

onready var currently_selected_slot_index : int = 1

const item = preload("res://scripts/resources/Item.gd")
const MAX_INVENTORY_SLOTS : int = 5
const MAX_INVENTORY_SLOTS_ROWS : int = 5
const MAX_INVENTORY_SLOTS_COLUMNS : int = 1

const SLOT_INDEX_POSITION_IN_STRING : int = 4


func _ready():
	visible = false
	get_parent().get_node("InventoryIcon/BagSprite").texture = closed
	add_item_to_inventory(item.new(item.ID.HEALTH_POTION), 1)
	add_item_to_inventory(item.new(item.ID.HEALTH_POTION), 2)
	add_item_to_inventory(item.new(item.ID.LARGE_HEALTH_POTION), 1)
	
#	yield(get_tree().create_timer(2),"timeout")
#	remove_item_from_inventory(item.new(item.ID.HEALTH_POTION), 1)
#	remove_item_from_inventory(item.new(item.ID.HEALTH_POTION), 1)
#	remove_item_from_inventory(item.new(item.ID.HEALTH_POTION), 1)
	
	inventory_grid_container.get_node("InventoryItemSlotCanvasLayer" + str(currently_selected_slot_index) + "/Control/SelectorTextureRect").visible = true
	update_item_description_text(inventory_grid_container.get_node("InventoryItemSlotCanvasLayer" + str(currently_selected_slot_index) + "/Control").get_contained_item())

func _process(delta):
	if !visible:
		if Input.is_action_just_pressed("ui_toggle_inventory") and Global.game_paused_by == "":
			open_menu()
	else:
		if Input.is_action_just_pressed("ui_toggle_inventory") or Input.is_action_just_pressed("ui_cancel"):
			close_menu()
		
	if visible:
		
		# Handle directional key inputs
		if Input.is_action_just_pressed("right") and currently_selected_slot_index < MAX_INVENTORY_SLOTS_ROWS:
			inventory_grid_container.get_node("InventoryItemSlotCanvasLayer" + str(currently_selected_slot_index) + "/Control/SelectorTextureRect").visible = false
			currently_selected_slot_index += 1
			inventory_grid_container.get_node("InventoryItemSlotCanvasLayer" + str(currently_selected_slot_index) + "/Control/SelectorTextureRect").visible = true
			update_item_description_text(inventory_grid_container.get_node("InventoryItemSlotCanvasLayer" + str(currently_selected_slot_index) + "/Control").get_contained_item())
		elif Input.is_action_just_pressed("left") and currently_selected_slot_index > 1:
			inventory_grid_container.get_node("InventoryItemSlotCanvasLayer" + str(currently_selected_slot_index) + "/Control/SelectorTextureRect").visible = false
			currently_selected_slot_index -= 1
			inventory_grid_container.get_node("InventoryItemSlotCanvasLayer" + str(currently_selected_slot_index) + "/Control/SelectorTextureRect").visible = true
			update_item_description_text(inventory_grid_container.get_node("InventoryItemSlotCanvasLayer" + str(currently_selected_slot_index) + "/Control").get_contained_item())
		elif Input.is_action_just_pressed("ui_down") and currently_selected_slot_index < MAX_INVENTORY_SLOTS_COLUMNS:
			pass
		elif Input.is_action_just_pressed("ui_up") and currently_selected_slot_index > 1:
			pass
		

func _gui_input(event):
	# WIP mouse input
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		print("Clicked on this UI node: ", self.name)

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
			slot_index = int(item_slot.substr(SLOT_INDEX_POSITION_IN_STRING))
			is_new_item = false
			break
		elif Global.current_player_inventory[item_category][item_slot]["ContainedItem"].get_id() == obtained_item.get_id():
			Global.current_player_inventory[item_category][item_slot]["ContainedItemAmount"] += amount
			slot_index = int(item_slot.substr(SLOT_INDEX_POSITION_IN_STRING))
			is_new_item = true
			break
		
	# update inventory slot ui
	var slot_control : InventoryItemSlot = inventory_grid_container.get_node("InventoryItemSlotCanvasLayer" + str(slot_index) + "/Control")
	slot_control.register_contained_item(obtained_item)
	slot_control.increment_item_count(amount)
	

	# debug, print inventory contents
	print("ADDED NEW ITEM: " + str(amount) + " " + obtained_item.get_name())
	print_inventory_contents()

# assumes the item exists in the inventory, with a quantity > 0
func remove_item_from_inventory(removed_item : item, amount : int):
	var item_category : String = ""
	var slot_index : int = -1
	match removed_item.get_category():
		item.CATEGORY.POTIONS:
			item_category = "PotionsCategory"
	
	for item_slot in Global.current_player_inventory[item_category]:
		if Global.current_player_inventory[item_category][item_slot]["ContainedItem"].get_id() == removed_item.get_id():
			Global.current_player_inventory[item_category][item_slot]["ContainedItemAmount"] -= amount
			slot_index = int(item_slot.substr(4))
			break
	
	# update inventory slot ui
	var slot_control : InventoryItemSlot = inventory_grid_container.get_node("InventoryItemSlotCanvasLayer" + str(slot_index) + "/Control")
	slot_control.decrement_item_count(amount)
	
	# if the item count is 0, clear item from the slot. 
	if Global.current_player_inventory[item_category]["Slot" + str(slot_index)]["ContainedItemAmount"] <= 0:
		Global.current_player_inventory[item_category]["Slot" + str(slot_index)]["ContainedItem"] = null
		Global.current_player_inventory[item_category]["Slot" + str(slot_index)]["ContainedItemAmount"] = 0
		slot_control.clear_contained_item()
		
		# TODO: rearrange items after deleting an item that gets reduced to 0
		var current_misplaced_empty_slot_index : int = slot_index
		for item_slot in Global.current_player_inventory[item_category]:
			if current_misplaced_empty_slot_index + 1 >= MAX_INVENTORY_SLOTS:
				break
				
			if Global.current_player_inventory[item_category]["Slot" + str(current_misplaced_empty_slot_index)]["ContainedItemAmount"] <= 0: 
				if Global.current_player_inventory[item_category]["Slot" + str(current_misplaced_empty_slot_index + 1)]["ContainedItem"] != null:
					Global.current_player_inventory[item_category]["Slot" + str(current_misplaced_empty_slot_index)]["ContainedItem"] = Global.current_player_inventory[item_category]["Slot" + str(current_misplaced_empty_slot_index + 1)]["ContainedItem"]
					Global.current_player_inventory[item_category]["Slot" + str(current_misplaced_empty_slot_index)]["ContainedItemAmount"] = Global.current_player_inventory[item_category]["Slot" + str(current_misplaced_empty_slot_index + 1)]["ContainedItemAmount"]
					
					var current_slot_control : InventoryItemSlot = inventory_grid_container.get_node("InventoryItemSlotCanvasLayer" + str(current_misplaced_empty_slot_index) + "/Control")
					current_slot_control.register_contained_item(Global.current_player_inventory[item_category]["Slot" + str(current_misplaced_empty_slot_index)]["ContainedItem"])
					current_slot_control.increment_item_count(Global.current_player_inventory[item_category]["Slot" + str(current_misplaced_empty_slot_index)]["ContainedItemAmount"])
					
					var next_slot_control : InventoryItemSlot = inventory_grid_container.get_node("InventoryItemSlotCanvasLayer" + str(current_misplaced_empty_slot_index + 1) + "/Control")
					next_slot_control.clear_contained_item()
			
			current_misplaced_empty_slot_index += 1


	# debug, print inventory contents
	print("REMOVED ITEM: " + str(amount) + " " + removed_item.get_name())
	print_inventory_contents()
	
	

func item_exists_in_inventory(item : item) -> bool:
	# TODO
	return true


func show_inventory_item_slots():
	for child in inventory_grid_container.get_children():
		child.get_node("Control").show_self()

func hide_inventory_item_slots():
	for child in inventory_grid_container.get_children():
		child.get_node("Control").hide_self()

func update_item_description_text(new_item : item):
	# Invalid call. Nonexistent function 'get_description' in base 'Nil'.
	if new_item == null:
		$BelongingsControl/DescriptionNinePatchRect/ScrollContainer/VBoxContainer/RichTextLabel.bbcode_text = ""
		return
	$BelongingsControl/DescriptionNinePatchRect/ScrollContainer/VBoxContainer/RichTextLabel.bbcode_text = new_item.get_description()

func update_footer_text():
	var text : String = "[center][color=#ffd703]LEFT[/color] and [color=#ffd703]RIGHT[/color] to move, [color=#ffd703]ATTACK[/color] to select."
	text = text.replace("LEFT", str(InputMap.get_action_list("left")[0].as_text()))
	text = text.replace("RIGHT", str(InputMap.get_action_list("right")[0].as_text()))
	text = text.replace("ATTACK", str(InputMap.get_action_list("ui_attack")[0].as_text()))
	$Footer.bbcode_text = text
	
# UTILITY FUNCTION
func print_inventory_contents():
	print("CURRENT INVENTORY: ")
	for i in Global.current_player_inventory["PotionsCategory"]:
		if Global.current_player_inventory["PotionsCategory"][i]["ContainedItem"] == null:
			print(i + " null")
		else:
			print(i + " " + str(Global.current_player_inventory["PotionsCategory"][i]["ContainedItemAmount"]) + " " + Global.current_player_inventory["PotionsCategory"][i]["ContainedItem"].get_name())

func open_menu():
	get_parent().layer = 5
	get_tree().paused = true
	show_inventory_item_slots()
	Global.game_paused_by = "InventoryUI"
	update_footer_text()
	visible = true

func close_menu():
	get_parent().layer = 1
	get_tree().paused = false
	hide_inventory_item_slots()
	Global.game_paused_by = ""
	visible = false
