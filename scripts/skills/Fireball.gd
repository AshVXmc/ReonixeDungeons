class_name Fireball extends Area2D
const BURNING : PackedScene = preload("res://scenes/status_effects/BurningStatus.tscn")
const TYPE : String = "Fireball"
var SPEED : int = 550
var attack : int = 5
var velocity = Vector2()
var direction : int = 1
var destroyed : bool = false
signal add_mana_to_player(amount)

func _ready():
	connect("add_mana_to_player", get_parent().get_node("Player"), "change_mana_value")
	if Global.player_talents["PiercingFervor"]["unlocked"] and Global.player_talents["PiercingFervor"]["enabled"]: 
		add_to_group(str((1 - Global.player_talents["PiercingFervor"]["damagepenalty"] / 100) * Global.attack_power * (Global.player_skill_multipliers["Fireball"] / 100)))
	else:
		add_to_group(str(Global.attack_power * (Global.player_skill_multipliers["Fireball"] / 100)))
#	print(get_groups())

func _physics_process(delta):
	
	if !destroyed:
		velocity.x = SPEED * delta * direction
		$AnimatedSprite.play("Shoot")
		$AnimatedSprite.flip_h = false if direction > 0 else true
	else:
		velocity.x = 0
	translate(velocity)
		
func add_burning_stack():
	var enemy = get_overlapping_areas()
	for e in enemy:
		if e.is_in_group("Enemy"):
			if !e.is_in_group("Burnstack"):
				var burning_status = BURNING.instance()
				e.add_child(burning_status)
	
func override_speed(ovr_speed : int):
	SPEED = ovr_speed


			
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Fireball_area_entered(area):
	if area.is_in_group("Enemy") or area.is_in_group("DestructableObject") or area.is_in_group("Campfire"):
		add_burning_stack()
		emit_signal("add_mana_to_player", 0.5)
		if !Global.player_talents["PiercingFervor"]["enabled"]:
			destroyed = true
			$AnimatedSprite.play("Destroyed")
			$CollisionShape2D.disabled = true
			yield(get_tree().create_timer(0.25), "timeout")
			queue_free()

func explode():
	destroyed = true
	$AnimatedSprite.scale.x = 6.5
	$AnimatedSprite.scale.y = 6.5 
	$AnimatedSprite.play("Destroyed")
	$CollisionShape2D.disabled = true
	yield(get_tree().create_timer(0.25), "timeout")
	call_deferred('free')

func _on_Fireball_body_entered(body):
	if !Global.player_talents["PiercingFervor"]["enabled"]:
		explode()

func _on_DestroyedTimer_timeout():
	explode()
