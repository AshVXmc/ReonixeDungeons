class_name ChestKey extends Node2D

# chestID is the same as chestkeyID.
# so chestID 7 would be unlocked by a key of ID 7
export var chest_keyID : int = -1 # value is -1 if not assigned to any locked chest

func _ready():
	name = name + "_" + str(chest_keyID)
	if Global.opened_chests.has(chest_keyID):
		call_deferred('free')

func reparent_to_player(new_parent : Player):
	if get_parent() != null:
		get_parent().remove_child(self)
		new_parent.add_child(self)
		
#		print("New parent: " + str(get_parent()))
#		print("Name under parent: " + str(name))


func _on_Area2D_area_entered(area):
	if area.is_in_group("Player"):
		reparent_to_player(area.get_parent())
