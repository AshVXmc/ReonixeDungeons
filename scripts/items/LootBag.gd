class_name LootBag extends RigidBody2D

export (int) var opals_amount = 0
export (Dictionary) var drops_table = {
	"common_dust": 0,
	"goblin_scales": 0,
	"bat_wings": 0,
	"sweet_herbs": 0
}
onready var PLAYER = get_parent().get_node("Player")

func _ready():
	set_collision_mask_bit(1, true)
	set_collision_mask_bit(5, true)

func _on_Area2D_area_entered(area):
	if area.is_in_group("Player"):
		call_deferred('free')
