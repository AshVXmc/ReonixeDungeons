class_name ElderSpider extends Spider

var current_state
enum state {
	IDLE, POISON_ATTACK
}

#func _ready():
#	current_state = state.POISON_ATTACK

func _physics_process(delta):
	if !is_staggered:
		if current_state == state.IDLE:
			velocity.x = SPEED * direction
		if current_state == state.POISON_ATTACK:
			$AnimatedSprite.play("AttackPoison")
