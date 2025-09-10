extends Control


func _on_RegenTimer_timeout():
	if $TextureProgress.value < $TextureProgress.max_value:
		$TextureProgress.value += 10
