class_name InventoryUI extends Control

onready var closed = preload("res://assets/misc/item_pouch.png")
onready var opened = preload("res://assets/misc/item_pouch_opened.png")
onready var player : KinematicBody2D = get_parent().get_parent().get_node("Player")
onready var inventory_grid_container : GridContainer = $BelongingsControl/NinePatchRect/ScrollContainer/VBoxContainer/PotionsInventoryGridContainer
onready var skills_ui : Control = get_parent().get_parent().get_node("SkillsUI/Control")
onready var currently_selected_slot_index : int = 1
const FULL_HEALTH_WARNING_TEXT : String = "[center][color=red]This character's health is full.[/color]"
const CHARACTER_STILL_ALIVE_WARNING_TEXT : String = "[center][color=red]Can only be used on a downed character.[/color]"
const item = preload("res://scripts/resources/Item.gd")
const PLAYER_SPRITE = preload("res://assets/characters/player/player_idle.png")
const GLACIELA_SPRITE = preload("res://assets/characters/glaciela/glaciela_idle.png")
const AGNETTE_SPRITE = preload("res://assets/characters/agnette/agnette_dash.png")
const MAX_INVENTORY_SLOTS : int = 5
const MAX_INVENTORY_SLOTS_ROWS : int = 5
const MAX_INVENTORY_SLOTS_COLUMNS : int = 1
const SLOT_INDEX_POSITION_IN_STRING : int = 4
const COLOR_YELLOW : Color = Color(1, 0.84, 0.01)
const COLOR_WHITE : Color = Color(1, 1, 1)
enum INVENTORY_CATEGORY {
	POTIONS,
	ARMOR,
	SPELL_SCROLLS
}

func _ready():
	visible = false
	get_parent().get_node("InventoryIcon/BagSprite").texture = closed

	
	
	
#	yield(get_tree().create_timer(2),"timeout")
#	remove_item_from_inventory(item.new(item.ID.HEALTH_POTION), 1)
#	remove_item_from_inventory(item.new(item.ID.HEALTH_POTION), 1)
#	remove_item_from_inventory(item.new(item.ID.HEALTH_POTION), 1)
	
	inventory_grid_container.get_node("InventoryItemSlotCanvasLayer" + str(currently_selected_slot_index) + "/Control/SelectorTextureRect").visible = true
	update_item_description_text(inventory_grid_container.get_node("InventoryItemSlotCanvasLayer" + str(currently_selected_slot_index) + "/Control").get_contained_item())
	

	hide_inventory_item_slots()
# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument
# warning-ignore:unused_argument

func _process(delta):
	# debug: press P to add item. 
	if Input.is_action_just_pressed("filler_button"):
		add_item_to_inventory(item.new(item.ID.HEALTH_POTION), 1)
		add_item_to_inventory(item.new(item.ID.HEALTH_POTION), 1)
		add_item_to_inventory(item.new(item.ID.LARGE_HEALTH_POTION), 1)
		add_item_to_inventory(item.new(item.ID.REVIVIFY_SPELL_SCROLL), 1)
		add_item_to_inventory(item.new(item.ID.DUSTY_SCARF), 1, false)
		add_item_to_inventory(item.new(item.ID.DUSTY_SCARF), 1, false)
	
	if !visible:
		if Input.is_action_just_pressed("ui_toggle_inventory") and Global.game_paused_by == "":
			open_menu()
	else:
		if !$SelectCharacterAsTargetControl.visible:
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
		elif Input.is_action_just_pressed("ui_attack"):
			var item = inventory_grid_container.get_node("InventoryItemSlotCanvasLayer" + str(currently_selected_slot_index) + "/Control").get_contained_item()
			if item != null:
#				print("currently selected item: " + str(item.get_name()))
				$SelectCharacterAsTargetControl.open_ui(item)
				hide_inventory_item_slots()
#				remove_item_from_inventory(item, 1)
		if !$SelectCharacterAsTargetControl.visible:
			if Input.is_action_just_pressed("slot_1"):
				update_current_inventory_category(INVENTORY_CATEGORY.POTIONS)
			elif Input.is_action_just_pressed("slot_2"):
				update_current_inventory_category(INVENTORY_CATEGORY.ARMOR)
			elif Input.is_action_just_pressed("slot_3"):
				update_current_inventory_category(INVENTORY_CATEGORY.SPELL_SCROLLS)
	if $SelectCharacterAsTargetControl.visible:
		if Input.is_action_just_pressed("ui_cancel") or Input.is_action_just_pressed("ui_toggle_inventory"):
			$SelectCharacterAsTargetControl.close_ui()
			show_inventory_item_slots()
		
		# handle inputting 1, 2 or 3
		if $ItemConsumptionDelayTimer.is_stopped():
			if Input.is_action_just_pressed("slot_1"):
				var item = inventory_grid_container.get_node("InventoryItemSlotCanvasLayer" + str(currently_selected_slot_index) + "/Control").get_contained_item()
				consume_item(item, 0, currently_selected_slot_index)
				$ItemConsumptionDelayTimer.start()
			elif Input.is_action_just_pressed("slot_2"):
				var item = inventory_grid_container.get_node("InventoryItemSlotCanvasLayer" + str(currently_selected_slot_index) + "/Control").get_contained_item()
				consume_item(item, 1, currently_selected_slot_index)
				$ItemConsumptionDelayTimer.start()
			elif Input.is_action_just_pressed("slot_3"):
				var item = inventory_grid_container.get_node("InventoryItemSlotCanvasLayer" + str(currently_selected_slot_index) + "/Control").get_contained_item()
				consume_item(item, 2, currently_selected_slot_index)
				$ItemConsumptionDelayTimer.start()

func consume_item(item : item, character_index : int, slot_index : int):
	if item.get_category() == item.CATEGORY.POTIONS:
		parse_healing_item_consumption(item, character_index)
	if item.get_category() == item.CATEGORY.SPELL_SCROLLS:
		if item.get_id() == item.ID.REVIVIFY_SPELL_SCROLL:
			parse_revival_item_consumption(item, character_index)
	if item.get_category() == item.CATEGORY.ARMOR:
		parse_armor_item_equipping(item, character_index, slot_index)

func parse_revival_item_consumption(revival_item: item, character_index : int):
	if revival_item.only_usable_when_dead:
		if Global.alive[character_index]:
			$SelectCharacterAsTargetControl/WarningRichTextLabel.bbcode_text = CHARACTER_STILL_ALIVE_WARNING_TEXT
			$SelectCharacterAsTargetControl/WarningRichTextLabel.visible = true
			return
	
		match Global.equipped_characters[character_index]:
			"Player":
				player.is_dead = false
				Global.alive[character_index] = true
				player.heal(Global.equipped_characters[character_index], revival_item.health_restored.REVIVIFY_SPELL_SCROLL)
				skills_ui.on_player_revival("Player")
				$SelectCharacterAsTargetControl.update_ui()
				remove_item_from_inventory(revival_item, 1)
				if !item_exists_in_inventory(revival_item):
					show_inventory_item_slots()
					$SelectCharacterAsTargetControl.close_ui()
			# for modularity. as more characters are added, i might not need to add anything down here.
			"Glaciela":
				player.get_node("CharacterManager/Glaciela").is_dead = false
				Global.alive[character_index] = true
				player.get_node("CharacterManager/Glaciela").heal(Global.equipped_characters[character_index], revival_item.health_restored.REVIVIFY_SPELL_SCROLL)
				player.get_node("CharacterManager/Glaciela/AnimatedSprite").self_modulate = Color(1,1,1)
				skills_ui.on_player_revival("Glaciela")
				$SelectCharacterAsTargetControl.update_ui()
				remove_item_from_inventory(revival_item, 1)
				if !item_exists_in_inventory(revival_item):
					show_inventory_item_slots()
					$SelectCharacterAsTargetControl.close_ui()
			"Agnette":
				player.get_node("CharacterManager/Agnette").is_dead = false
				Global.alive[character_index] = true
				player.get_node("CharacterManager/Agnette").heal(Global.equipped_characters[character_index], revival_item.health_restored.REVIVIFY_SPELL_SCROLL)
				player.get_node("CharacterManager/Agnette/AnimatedSprite").self_modulate = Color(1,1,1)
				skills_ui.on_player_revival("Agnette")
				$SelectCharacterAsTargetControl.update_ui()
				remove_item_from_inventory(revival_item, 1)
				if !item_exists_in_inventory(revival_item):
					show_inventory_item_slots()
					$SelectCharacterAsTargetControl.close_ui()
			# for modularity. as more characters are added, i might not need to add anything down here.

func parse_healing_item_consumption(healing_item : item, character_index : int):
	if !Global.alive[character_index]:
		return
	$SelectCharacterAsTargetControl/WarningRichTextLabel.bbcode_text = FULL_HEALTH_WARNING_TEXT
	match character_index:
		0:
			if Global.hearts == Global.max_hearts:
				$SelectCharacterAsTargetControl/WarningRichTextLabel.visible = true
				return
		1:
			if Global.character2_hearts == Global.character_2_max_hearts:
				$SelectCharacterAsTargetControl/WarningRichTextLabel.visible = true
				return
		2:
			if Global.character3_hearts == Global.character_3_max_hearts:
				$SelectCharacterAsTargetControl/WarningRichTextLabel.visible = true
				return
	$SelectCharacterAsTargetControl/WarningRichTextLabel.visible = false
	match healing_item.get_id():
		item.ID.HEALTH_POTION:
			player.heal(Global.equipped_characters[character_index], healing_item.health_restored.HEALTH_POTION)
		item.ID.LARGE_HEALTH_POTION:
			player.heal(Global.equipped_characters[character_index], healing_item.health_restored.LARGE_HEALTH_POTION)
		_:
			print("Not a valid healing item. (Source: InventoryControl.gd)")
	$SelectCharacterAsTargetControl.update_ui()
	remove_item_from_inventory(healing_item, 1)
	

	if !item_exists_in_inventory(healing_item):
		show_inventory_item_slots()
		$SelectCharacterAsTargetControl.close_ui()

func parse_armor_item_equipping(armor_item : item, character_index : int, slot_index : int):
	if armor_item.get_is_equipped_on() != "":
		return
	# TODO: handle swapping armor between two distinct characters
	
	var character : String = Global.equipped_characters[character_index]
	for inventory_item_slot in $BelongingsControl/NinePatchRect/ScrollContainer/VBoxContainer/ArmorInventoryGridContainer.get_children():
		if inventory_item_slot.get_node("Control").get_contained_item() != null:
			if inventory_item_slot.get_node("Control").get_contained_item().get_is_equipped_on() == character:
				inventory_item_slot.get_node("Control").get_contained_item().clear_is_equipped_on()
				inventory_item_slot.get_node("Control").clear_equipping_character_sprite()
				break
	Global.equipped_character_armor[character] = armor_item
	armor_item.is_equipped_on = character
	print("Equipped " + str(Global.equipped_character_armor[character].get_name()) + " on " + character + ", in slot index " + str(slot_index))
	
	var sprite : Texture
	match character:
		"Player":
			sprite = PLAYER_SPRITE
		"Glaciela":
			sprite = GLACIELA_SPRITE
		"Agnette":
			sprite = AGNETTE_SPRITE
	inventory_grid_container.get_node("InventoryItemSlotCanvasLayer" + str(currently_selected_slot_index) + "/Control").set_equipping_character_sprite(sprite)
	show_inventory_item_slots()
	$SelectCharacterAsTargetControl.close_ui()
	

func add_item_to_inventory(obtained_item : item, amount : int, is_stackable : bool = true):
	var item_category : String = ""
	var slot_index : int = -1
	match obtained_item.get_category():
		item.CATEGORY.POTIONS:
			item_category = "PotionsCategory"
			update_current_inventory_category(INVENTORY_CATEGORY.POTIONS)
		item.CATEGORY.SPELL_SCROLLS:
			item_category = "SpellScrollsCategory"
			update_current_inventory_category(INVENTORY_CATEGORY.SPELL_SCROLLS)
		item.CATEGORY.ARMOR:
			item_category = "ArmorCategory"
			update_current_inventory_category(INVENTORY_CATEGORY.ARMOR)
	for item_slot in Global.current_player_inventory[item_category]:
		if is_stackable:
			if Global.current_player_inventory[item_category][item_slot]["ContainedItem"] == null:
				Global.current_player_inventory[item_category][item_slot]["ContainedItem"] = obtained_item
				Global.current_player_inventory[item_category][item_slot]["ContainedItemAmount"] += amount
				slot_index = int(item_slot.substr(SLOT_INDEX_POSITION_IN_STRING))
				break
			elif Global.current_player_inventory[item_category][item_slot]["ContainedItem"].get_id() == obtained_item.get_id():
				Global.current_player_inventory[item_category][item_slot]["ContainedItemAmount"] += amount
				slot_index = int(item_slot.substr(SLOT_INDEX_POSITION_IN_STRING))
				break
#			print("potions: " + str(Global.current_player_inventory["PotionsCategory"]))
			
		else:
			if Global.current_player_inventory[item_category][item_slot]["ContainedItem"] == null:
				Global.current_player_inventory[item_category][item_slot]["ContainedItem"] = obtained_item
				slot_index = int(item_slot.substr(SLOT_INDEX_POSITION_IN_STRING))
#				print("armor: " + str(Global.current_player_inventory["ArmorCategory"]))
				break
		
	# update inventory slot ui

	var slot_control = inventory_grid_container.get_node("InventoryItemSlotCanvasLayer" + str(slot_index) + "/Control")
	slot_control.register_contained_item(obtained_item)
	
	if is_stackable:
		slot_control.increment_item_count(amount)
	# debug, print inventory contents
#	print("ADDED NEW ITEM: " + str(amount) + " " + obtained_item.get_name())
#	print_inventory_contents()

# assumes the item exists in the inventory, with a quantity > 0
func remove_item_from_inventory(removed_item : item, amount : int):
	var item_category : String = ""
	var slot_index : int = -1
	match removed_item.get_category():
		item.CATEGORY.POTIONS:
			item_category = "PotionsCategory"
		item.CATEGORY.SPELL_SCROLLS:
			item_category = "SpellScrollsCategory"
		item.CATEGORY.ARMOR:
			item_category = "ArmorCategory"
	for item_slot in Global.current_player_inventory[item_category]:
		if Global.current_player_inventory[item_category][item_slot]["ContainedItem"].get_id() == removed_item.get_id():
			Global.current_player_inventory[item_category][item_slot]["ContainedItemAmount"] -= amount
			slot_index = int(item_slot.substr(4))
			break
	
	# update inventory slot ui
	var slot_control = inventory_grid_container.get_node("InventoryItemSlotCanvasLayer" + str(slot_index) + "/Control")
	slot_control.decrement_item_count(amount)
	
	# if the item count is 0, clear item from the slot. 
	if Global.current_player_inventory[item_category]["Slot" + str(slot_index)]["ContainedItemAmount"] <= 0:
		Global.current_player_inventory[item_category]["Slot" + str(slot_index)]["ContainedItem"] = null
		Global.current_player_inventory[item_category]["Slot" + str(slot_index)]["ContainedItemAmount"] = 0
		slot_control.clear_contained_item()
		var current_misplaced_empty_slot_index : int = slot_index
		for item_slot in Global.current_player_inventory[item_category]:
			if current_misplaced_empty_slot_index + 1 >= MAX_INVENTORY_SLOTS:
				break
				
			if Global.current_player_inventory[item_category]["Slot" + str(current_misplaced_empty_slot_index)]["ContainedItemAmount"] <= 0: 
				if Global.current_player_inventory[item_category]["Slot" + str(current_misplaced_empty_slot_index + 1)]["ContainedItem"] != null:
					Global.current_player_inventory[item_category]["Slot" + str(current_misplaced_empty_slot_index)]["ContainedItem"] = Global.current_player_inventory[item_category]["Slot" + str(current_misplaced_empty_slot_index + 1)]["ContainedItem"]
					Global.current_player_inventory[item_category]["Slot" + str(current_misplaced_empty_slot_index)]["ContainedItemAmount"] = Global.current_player_inventory[item_category]["Slot" + str(current_misplaced_empty_slot_index + 1)]["ContainedItemAmount"]
					
					var current_slot_control = inventory_grid_container.get_node("InventoryItemSlotCanvasLayer" + str(current_misplaced_empty_slot_index) + "/Control")
					current_slot_control.register_contained_item(Global.current_player_inventory[item_category]["Slot" + str(current_misplaced_empty_slot_index)]["ContainedItem"])
					current_slot_control.increment_item_count(Global.current_player_inventory[item_category]["Slot" + str(current_misplaced_empty_slot_index)]["ContainedItemAmount"])
					
					var next_slot_control = inventory_grid_container.get_node("InventoryItemSlotCanvasLayer" + str(current_misplaced_empty_slot_index + 1) + "/Control")
					Global.current_player_inventory[item_category]["Slot" + str(current_misplaced_empty_slot_index + 1)]["ContainedItem"] = null
					Global.current_player_inventory[item_category]["Slot" + str(current_misplaced_empty_slot_index + 1)]["ContainedItemAmount"] = 0
					
					next_slot_control.clear_contained_item()
			
			current_misplaced_empty_slot_index += 1
	# debug, print inventory contents
#	print("REMOVED ITEM: " + str(amount) + " " + removed_item.get_name())
#	print_inventory_contents()

func item_exists_in_inventory(target_item : item) -> bool:
	match target_item.get_category():
		item.CATEGORY.POTIONS:
			for item_slot in Global.current_player_inventory["PotionsCategory"]:
				if Global.current_player_inventory["PotionsCategory"][item_slot]["ContainedItem"] == null:
					continue
				if Global.current_player_inventory["PotionsCategory"][item_slot]["ContainedItem"].get_id() == target_item.get_id() and Global.current_player_inventory["PotionsCategory"][item_slot]["ContainedItemAmount"] > 0:
					return true
		item.CATEGORY.SPELL_SCROLLS:
			for item_slot in Global.current_player_inventory["SpellScrollsCategory"]:
				if Global.current_player_inventory["SpellScrollsCategory"][item_slot]["ContainedItem"] == null:
					continue
				if Global.current_player_inventory["SpellScrollsCategory"][item_slot]["ContainedItem"].get_id() == target_item.get_id() and Global.current_player_inventory["SpellScrollsCategory"][item_slot]["ContainedItemAmount"] > 0:
					return true
		item.CATEGORY.ARMOR:
			for item_slot in Global.current_player_inventory["ArmorCategory"]:
				if Global.current_player_inventory["ArmorCategory"][item_slot]["ContainedItem"] == null:
					continue
				if Global.current_player_inventory["ArmorCategory"][item_slot]["ContainedItem"].get_id() == target_item.get_id():
					return true
	return false


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

func update_current_inventory_category(new_category : int):
	match new_category:
		INVENTORY_CATEGORY.POTIONS:
			$BelongingsControl/NinePatchRect/PotionsTextureButton/Label.add_color_override("font_color", COLOR_YELLOW)
			$BelongingsControl/NinePatchRect/ArmorTextureButton/Label.add_color_override("font_color", COLOR_WHITE)
			$BelongingsControl/NinePatchRect/SpellScrollsTextureButton/Label.add_color_override("font_color", COLOR_WHITE)
			inventory_grid_container.get_node("InventoryItemSlotCanvasLayer" + str(currently_selected_slot_index) + "/Control/SelectorTextureRect").visible = false
			currently_selected_slot_index = 1
			inventory_grid_container.get_node("InventoryItemSlotCanvasLayer" + str(currently_selected_slot_index) + "/Control/SelectorTextureRect").visible = true
			hide_inventory_item_slots()
			inventory_grid_container = $BelongingsControl/NinePatchRect/ScrollContainer/VBoxContainer/PotionsInventoryGridContainer
			update_item_description_text(inventory_grid_container.get_node("InventoryItemSlotCanvasLayer" + str(currently_selected_slot_index) + "/Control").get_contained_item())
			show_inventory_item_slots()
			inventory_grid_container.get_node("InventoryItemSlotCanvasLayer" + str(currently_selected_slot_index) + "/Control/SelectorTextureRect").visible = false
			currently_selected_slot_index = 1
			inventory_grid_container.get_node("InventoryItemSlotCanvasLayer" + str(currently_selected_slot_index) + "/Control/SelectorTextureRect").visible = true
		INVENTORY_CATEGORY.SPELL_SCROLLS:
			$BelongingsControl/NinePatchRect/PotionsTextureButton/Label.add_color_override("font_color", COLOR_WHITE)
			$BelongingsControl/NinePatchRect/ArmorTextureButton/Label.add_color_override("font_color", COLOR_WHITE)
			$BelongingsControl/NinePatchRect/SpellScrollsTextureButton/Label.add_color_override("font_color", COLOR_YELLOW)
			inventory_grid_container.get_node("InventoryItemSlotCanvasLayer" + str(currently_selected_slot_index) + "/Control/SelectorTextureRect").visible = false
			currently_selected_slot_index = 1
			inventory_grid_container.get_node("InventoryItemSlotCanvasLayer" + str(currently_selected_slot_index) + "/Control/SelectorTextureRect").visible = true
			hide_inventory_item_slots()
			inventory_grid_container = $BelongingsControl/NinePatchRect/ScrollContainer/VBoxContainer/SpellScrollsInventoryGridContainer
			update_item_description_text(inventory_grid_container.get_node("InventoryItemSlotCanvasLayer" + str(currently_selected_slot_index) + "/Control").get_contained_item())
			show_inventory_item_slots()
			inventory_grid_container.get_node("InventoryItemSlotCanvasLayer" + str(currently_selected_slot_index) + "/Control/SelectorTextureRect").visible = false
			currently_selected_slot_index = 1
			inventory_grid_container.get_node("InventoryItemSlotCanvasLayer" + str(currently_selected_slot_index) + "/Control/SelectorTextureRect").visible = true
		INVENTORY_CATEGORY.ARMOR:
			$BelongingsControl/NinePatchRect/PotionsTextureButton/Label.add_color_override("font_color", COLOR_WHITE)
			$BelongingsControl/NinePatchRect/ArmorTextureButton/Label.add_color_override("font_color", COLOR_YELLOW)
			$BelongingsControl/NinePatchRect/SpellScrollsTextureButton/Label.add_color_override("font_color", COLOR_WHITE)
			inventory_grid_container.get_node("InventoryItemSlotCanvasLayer" + str(currently_selected_slot_index) + "/Control/SelectorTextureRect").visible = false
			currently_selected_slot_index = 1
			inventory_grid_container.get_node("InventoryItemSlotCanvasLayer" + str(currently_selected_slot_index) + "/Control/SelectorTextureRect").visible = true
			hide_inventory_item_slots()
			inventory_grid_container = $BelongingsControl/NinePatchRect/ScrollContainer/VBoxContainer/ArmorInventoryGridContainer
			update_item_description_text(inventory_grid_container.get_node("InventoryItemSlotCanvasLayer" + str(currently_selected_slot_index) + "/Control").get_contained_item())
			show_inventory_item_slots()
			inventory_grid_container.get_node("InventoryItemSlotCanvasLayer" + str(currently_selected_slot_index) + "/Control/SelectorTextureRect").visible = false
			currently_selected_slot_index = 1
			inventory_grid_container.get_node("InventoryItemSlotCanvasLayer" + str(currently_selected_slot_index) + "/Control/SelectorTextureRect").visible = true

# UTILITY FUNCTION
func print_inventory_contents():
	print("CURRENT INVENTORY: ")
	for i in Global.current_player_inventory["PotionsCategory"]:
		if Global.current_player_inventory["PotionsCategory"][i]["ContainedItem"] == null:
			print(i + " null")
		else:
			print(i + " " + str(Global.current_player_inventory["PotionsCategory"][i]["ContainedItemAmount"]) + " " + Global.current_player_inventory["PotionsCategory"][i]["ContainedItem"].get_name())

func open_menu():
	visible = true
	get_tree().paused = true
	show_inventory_item_slots()
	update_footer_text()
	get_parent().layer = 5
	player.is_shopping = true
	Global.game_paused_by = "InventoryUI"

func close_menu():
	visible = false
	hide_inventory_item_slots()
	get_tree().paused = false
	get_parent().layer = 0
	player.is_shopping = false
	Global.game_paused_by = ""


func _on_CloseButtonMainUI_pressed():
	close_menu()

func _on_PotionsTextureButton_pressed():
	update_current_inventory_category(INVENTORY_CATEGORY.POTIONS)

func _on_ArmorTextureButton_pressed():
	update_current_inventory_category(INVENTORY_CATEGORY.ARMOR)

func _on_SpellScrollsTextureButton_pressed():
	update_current_inventory_category(INVENTORY_CATEGORY.SPELL_SCROLLS)




