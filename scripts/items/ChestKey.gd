class_name ChestKey extends Node2D

# chestID is the same as chestkeyID.
# so chestID 7 would be unlocked by a key of ID 7
export var chest_keyID : int = -1 # value is -1 if not assigned to any locked chest

func _ready():
	name = name + "_" + str(chest_keyID)
	if Global.opened_chests.has(chest_keyID):
		call_deferred('free')


func _on_Area2D_area_entered(area):
	if area.is_in_group("Player") and area.get_parent() != null:
		area.get_parent().add_to_group(str("HasChestKey_" + str(chest_keyID)))
		call_deferred('free')
