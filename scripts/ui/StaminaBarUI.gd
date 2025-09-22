class_name StaminaBarUI extends Control

const REGEN_VALUE : int = 10

# utility
func get_stamina_value() -> int:
	return $TextureProgress.value

func consume_stamina(amount : int):
	$TextureProgress.value -= amount

func _on_RegenTimer_timeout():
	$TextureProgress.value += REGEN_VALUE
