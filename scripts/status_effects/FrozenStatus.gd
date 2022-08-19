class_name FrozenStatus extends Area2D

# if the freeze stack reaches 0, the frozen debuff will be applied.
onready var freeze_stack = 100
onready var refresh_stack = 125
var is_frozen : bool = false
# Maximum duration of the freeze effect
onready var max_freeze_duration = $DestroyedTimer.wait_time

func _ready():
	$FreezeBar.visible = false
	$FreezeBar.value = $FreezeBar.max_value
	$CollisionShape2D.disabled = true
	if !get_parent().is_in_group("BurnStack"):
		get_parent().add_to_group("Burnstack")
		
#func _ready():
#	get_parent().remove_from_group("Enemy")
#	yield(get_tree().create_timer(2), "timeout")
#	get_parent().add_to_group("Enemy")
#	queue_free()



func _on_FrozenStatus_area_entered(area):
	if area.is_in_group("Fireball"):
		get_parent().add_to_group("Enemy")
		queue_free()


func _on_DestroyedTimer_timeout():
	pass # Replace with function body.
