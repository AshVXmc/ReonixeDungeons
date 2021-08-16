extends Sprite

func _ready():
	$Label.visible = false

func _on_Area2D2_area_entered(area):
	if area.is_in_group("Player") and !$Label.visible:
		$Label.visible = true


# warning-ignore:unused_argument
func _on_Area2D2_area_exited(area):
	$Label.visible = false
