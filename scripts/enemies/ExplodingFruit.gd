class_name ExplodingFruit extends Area2D

const SPEED : int = 400
var velocity = Vector2()
var direction : int = -1
const FIRE_PARTICLE = preload("res://scenes/particles/FlameParticle.tscn")
var detonating = false

func _ready():
	$AnimationPlayer.play("SPIN")
	$ExplodeTimer.start()
	

func _physics_process(delta):
	if !detonating:
		velocity.x = SPEED * delta * direction
	else:
		velocity.x = 0
	translate(velocity)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_ExplodeTimer_timeout():
	$AnimationPlayer.play("BLINK")
	yield(get_tree().create_timer(0.5), "timeout")
	# Exploding the fruit
	detonating = true
	$Area2D/CollisionShape2D.disabled = false
	$Sprite.visible = false
	var fireparticle1 = FIRE_PARTICLE.instance()
	var fireparticle2 = FIRE_PARTICLE.instance()
	var fireparticle3 = FIRE_PARTICLE.instance()
	add_child(fireparticle1)
	fireparticle1.emitting = true
	fireparticle1.one_shot = true
	fireparticle1.lifetime = 1.5
	fireparticle1.position = $Sprite.position
	
	yield(get_tree().create_timer(0.2), "timeout")
	
	add_child(fireparticle2)
	fireparticle2.emitting = true
	fireparticle2.one_shot = true
	fireparticle2.position = $Sprite.position
	fireparticle1.lifetime = 0.8
	yield(get_tree().create_timer(0.2), "timeout")
	
	add_child(fireparticle3)
	fireparticle3.emitting = true
	fireparticle3.one_shot = true
	fireparticle3.position = $Sprite.position
	fireparticle1.lifetime = 0.5
	yield(get_tree().create_timer(0.2), "timeout")
	queue_free()
	
