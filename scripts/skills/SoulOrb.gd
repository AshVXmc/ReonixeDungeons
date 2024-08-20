class_name SoulOrb extends Area2D

var add_health : float = Global.player_talents["SoulSiphon"]["healthgranted"]


func _on_DestroyedTimer_timeout():
	call_deferred('free')


func _on_SoulOrb_area_entered(area):
	if Global.current_character == "Player" and area.is_in_group("Player"):
		call_deferred('free')
