class_name FireFairy extends Area2D
onready var player = get_parent().get_node("Player")
const SULPHURIC_SIGIL = preload("res://scenes/status_effects/SulphuricSigil.tscn")
const BURNING : PackedScene = preload("res://scenes/status_effects/BurningStatus.tscn")
const SPEED = 500
const steer_force = 325
var attack : int = 5
var target = null
var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO
var atkbonus : float
signal add_mana_to_player(amount)
var is_exploding = false
func _ready():
	connect("add_mana_to_player", player, "change_mana_value")
	add_to_group(str(Global.attack_power * (Global.player_skill_multipliers["FireFairy"] / 100)))
	$AnimationPlayer.play("Flap")
	$DestroyedTimer.wait_time = Global.player_skill_multipliers["FireFairyDuration"]
	

func start(_transform, _target):
	global_transform = _transform
#	rotation += rand_range(-0.09, 0.09)
	velocity = transform.x * SPEED
	target = _target

func seek():
	var steer = Vector2.ZERO
	if target:
		var desired = (target.position - position).normalized() * SPEED
		steer = (desired - velocity).normalized() * steer_force
		return steer
	else:
		return 0


func _physics_process(delta):
	if Input.is_action_just_pressed("secondary_skill"):
		position = player.global_position
	if !is_exploding:
		target = get_closest_enemy()
		
		if weakref(target).get_ref() != null and target and target.get_node("Area2D").overlaps_area($Detector):
			acceleration += seek()
			velocity += acceleration * delta
			velocity = velocity.clamped(SPEED)
		#	rotation = velocity.angle()
			position += velocity * delta
func get_closest_enemy():
	var enemies = get_tree().get_nodes_in_group("EnemyEntity")
	if enemies.empty(): 
		return null
	var distances = []
	for enemy in enemies:
		var distance = player.global_position.distance_squared_to(enemy.global_position)
		distances.append(distance)
	var min_distance = distances.min()
	var min_index = distances.find(min_distance)
	var closest_enemy = enemies[min_index]
	return closest_enemy

func add_burning_stack():
	var enemy = get_overlapping_areas()
	for e in enemy:
		if e.is_in_group("Enemy"):
			if !e.is_in_group("Burnstack"):
				var burning_status = BURNING.instance()
				e.add_child(burning_status)

func _on_DestroyedTimer_timeout():
	explode()

func explode():
	is_exploding = true
	$AnimationPlayer.play("Flicker")
	yield(get_tree().create_timer(0.4), "timeout")
	$Sprite.visible = false
	$ExplodeArea2D.add_to_group(str(Global.attack_power * (Global.player_skill_multipliers["FireFairyDetonation"] / 100)))
	$ExplodeArea2D/CollisionShape2D.disabled = false
	$FireDetonationParticle.emitting = true
	yield(get_tree().create_timer(0.55), "timeout")
	call_deferred('free')
	
func _on_FireFairy_body_entered(body):
	if body.is_in_group("EnemyEntity") and !body.is_in_group("MarkedWithSulphuricSigil"):
		var sigil = SULPHURIC_SIGIL.instance()
		body.add_child(sigil)


func _on_FireFairy_area_entered(area):
	if area.is_in_group("Enemy"):
		add_burning_stack()
		emit_signal("add_mana_to_player", 0.4)
