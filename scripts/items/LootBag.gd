class_name LootBag extends RigidBody2D

export (int) var opals_amount = 0
export (Dictionary) var drops_table = {
	"common_dust": 0,
	"goblin_scales": 0,
	"bat_wings": 0,
	"sweet_herbs": 0
}
onready var PLAYER = get_parent().get_node("Player")
onready var OPALS_GAINED_INDICATOR_PARTICLE : PackedScene = preload("res://scenes/particles/OpalsGainedIndicatorParticle.tscn")
func _ready():
	set_collision_mask_bit(1, true)
	set_collision_mask_bit(5, true)

func _on_Area2D_area_entered(area):
	if area.is_in_group("Player"):
		if opals_amount > 0:
			var particle : OpalsGainedIndicatorParticle = OPALS_GAINED_INDICATOR_PARTICLE.instance()
			get_parent().add_child(particle)
			particle.position = global_position
			particle.opals_gained = opals_amount
			particle.play_opals_gained_animation()
		call_deferred('free')
