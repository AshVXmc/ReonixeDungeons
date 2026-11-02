extends Control
onready var currently_selected_slot_index : int = 1
const MAX_INVENTORY_SLOTS_ROWS : int = 5
const MAX_INVENTORY_SLOTS_COLUMNS : int = 3
const item = preload("res://scripts/resources/Item.gd")
const SLOT_INDEX_POSITION_IN_STRING : int = 4



func _ready():
	print("hi im an armor inventory control")
	visible = false
	hide_inventory_item_slots()
	$ScrollContainer/VBoxContainer/ArmorInventoryGridContainer.get_node("InventoryItemSlotCanvasLayer" + str(currently_selected_slot_index) + "/Control/SelectorTextureRect").visible = true


func _process(delta):
	if Input.is_action_just_pressed("filler_button"):
		add_armor_to_inventory(item.new(item.ID.DUSTY_SCARF), 1, false)

	if !visible:
		if Input.is_action_just_pressed("ui_toggle_inventory") and Global.game_paused_by == "":
			open_ui()
	else:
		if !$SelectCharacterAsTargetControl.visible:
			if Input.is_action_just_pressed("ui_toggle_inventory") or Input.is_action_just_pressed("ui_cancel"):
				close_ui()
		
	if visible:
		# Handle directional key inputs
		if Input.is_action_just_pressed("right") and currently_selected_slot_index < MAX_INVENTORY_SLOTS_ROWS:
			$ScrollContainer/VBoxContainer/ArmorInventoryGridContainer.get_node("InventoryItemSlotCanvasLayer" + str(currently_selected_slot_index) + "/Control/SelectorTextureRect").visible = false
			currently_selected_slot_index += 1
			$ScrollContainer/VBoxContainer/ArmorInventoryGridContainer.get_node("InventoryItemSlotCanvasLayer" + str(currently_selected_slot_index) + "/Control/SelectorTextureRect").visible = true
			update_item_description_text($ScrollContainer/VBoxContainer/ArmorInventoryGridContainer.get_node("InventoryItemSlotCanvasLayer" + str(currently_selected_slot_index) + "/Control").get_contained_item())
		elif Input.is_action_just_pressed("left") and currently_selected_slot_index > 1:
			$ScrollContainer/VBoxContainer/ArmorInventoryGridContainer.get_node("InventoryItemSlotCanvasLayer" + str(currently_selected_slot_index) + "/Control/SelectorTextureRect").visible = false
			currently_selected_slot_index -= 1
			$ScrollContainer/VBoxContainer/ArmorInventoryGridContainer.get_node("InventoryItemSlotCanvasLayer" + str(currently_selected_slot_index) + "/Control/SelectorTextureRect").visible = true
			update_item_description_text($ScrollContainer/VBoxContainer/ArmorInventoryGridContainer.get_node("InventoryItemSlotCanvasLayer" + str(currently_selected_slot_index) + "/Control").get_contained_item())
		elif Input.is_action_just_pressed("ui_down") and currently_selected_slot_index < MAX_INVENTORY_SLOTS_COLUMNS:
			pass
		elif Input.is_action_just_pressed("ui_up") and currently_selected_slot_index > 1:
			pass
		elif Input.is_action_just_pressed("ui_attack"):
			var item = $ScrollContainer/VBoxContainer/ArmorInventoryGridContainer.get_node("InventoryItemSlotCanvasLayer" + str(currently_selected_slot_index) + "/Control").get_contained_item()
			if item != null:
#				print("currently selected item: " + str(item.get_name()))
				$SelectCharacterAsTargetControl.open_ui(item)
				hide_inventory_item_slots()
#				remove_item_from_inventory(item, 1)
		
	if $SelectCharacterAsTargetControl.visible:
		if Input.is_action_just_pressed("ui_cancel") or Input.is_action_just_pressed("ui_toggle_inventory"):
			$SelectCharacterAsTargetControl.close_ui()
			show_inventory_item_slots()
		
		# handle inputting 1, 2 or 3
		if $ItemConsumptionDelayTimer.is_stopped():
			if Input.is_action_just_pressed("slot_1"):
				var item = $ScrollContainer/VBoxContainer/ArmorInventoryGridContainer.get_node("InventoryItemSlotCanvasLayer" + str(currently_selected_slot_index) + "/Control").get_contained_item()
				consume_item(item, 0, currently_selected_slot_index)
				$ItemConsumptionDelayTimer.start()
			elif Input.is_action_just_pressed("slot_2"):
				var item = $ScrollContainer/VBoxContainer/ArmorInventoryGridContainer.get_node("InventoryItemSlotCanvasLayer" + str(currently_selected_slot_index) + "/Control").get_contained_item()
				consume_item(item, 1, currently_selected_slot_index)
				$ItemConsumptionDelayTimer.start()
			elif Input.is_action_just_pressed("slot_3"):
				var item = $ScrollContainer/VBoxContainer/ArmorInventoryGridContainer.get_node("InventoryItemSlotCanvasLayer" + str(currently_selected_slot_index) + "/Control").get_contained_item()
				consume_item(item, 2, currently_selected_slot_index)
				$ItemConsumptionDelayTimer.start()
				
func add_armor_to_inventory(obtained_item : item, amount : int, is_stackable : bool = true):
	var slot_index : int = -1

	for item_slot in Global.current_player_inventory["ArmorCategory"]:
		if Global.current_player_inventory["ArmorCategory"][item_slot]["ContainedItem"] == null:
			Global.current_player_inventory["ArmorCategory"][item_slot]["ContainedItem"] = obtained_item
			slot_index = int(item_slot.substr(SLOT_INDEX_POSITION_IN_STRING))
			print("armor: " + str(Global.current_player_inventory["ArmorCategory"]))
			break
		
	var slot_control = $ScrollContainer/VBoxContainer/ArmorInventoryGridContainer.get_node("InventoryItemSlotCanvasLayer" + str(slot_index) + "/Control")
	slot_control.register_contained_item(obtained_item)
	
	
		
func consume_item(item, character_index : int, slot_index : int):
	pass
	# TODO
func update_item_description_text(new_item):
	# Invalid call. Nonexistent function 'get_description' in base 'Nil'.
	if new_item == null:
		$DescriptionNinePatchRect/ScrollContainer/VBoxContainer/RichTextLabel.bbcode_text = ""
		return
	$DescriptionNinePatchRect/ScrollContainer/VBoxContainer/RichTextLabel.bbcode_text = new_item.get_description()

func show_inventory_item_slots():
	for child in $ScrollContainer/VBoxContainer/ArmorInventoryGridContainer.get_children():
		child.get_node("Control").show_self()

func hide_inventory_item_slots():
	for child in $ScrollContainer/VBoxContainer/ArmorInventoryGridContainer.get_children():
		child.get_node("Control").hide_self()

func open_ui():
	visible = true
	show_inventory_item_slots()
	Global.game_paused_by = "ArmorInventoryControl"

func close_ui():
	visible = false
	hide_inventory_item_slots()
	Global.game_paused_by = ""

func _on_CloseButtonMainUI_pressed():
	close_ui()
	
