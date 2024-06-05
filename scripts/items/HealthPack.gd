class_name HealthPack extends Node2D

export var active : bool = true

func _on_Area2D_area_entered(area):
	if area.is_in_group("Player"):
		$HealthPackSprite.visible = false
		$AnimationPlayer.stop()
		$Area2D.remove_from_group("Active")
		$Area2D/CollisionShape2D.disabled = true
		active = false
