class_name FireFairy extends Area2D
onready var player = get_parent().get_node("Player")
const SULPHURIC_SIGIL = preload("res://scenes/status_effects/SulphuricSigil.tscn")
const BURNING : PackedScene = preload("res://scenes/status_effects/BurningStatus.tscn")
const SPEED = 350
const MAXED_ENERGY_METER = preload("res://assets/UI/energy_meter_maxed.png")
const steer_force = 325
var attack : int = 5
var target = null
var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO
var atkbonus : float
signal add_mana_to_player(amount)
var is_exploding = false
var is_joint_attacking : bool = false

var joint_attack_points : int = Global.player_skill_multipliers["FireFairyJointAttackPoints"]

func _ready():
	connect("add_mana_to_player", player, "change_mana_value")
	add_to_group(str(Global.attack_power * (Global.player_skill_multipliers["FireFairy"] / 100)))
	$JointAttackArea2D.add_to_group(str(Global.attack_power * (Global.player_skill_multipliers["FireFairyJointAttackSlash"] / 100)))
	$AnimationPlayer.play("Flap")
	$DestroyedTimer.wait_time = Global.player_skill_multipliers["FireFairyDuration"]
	$Sprite.visible = true
	$Sprite.position.x = 0
	$Sprite.position.y = 0
	$DestroyedTimer.start()
	yield(get_tree().create_timer(1), "timeout")
#	joint_attack()

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
	if Input.is_action_just_pressed("secondary_skill") and Global.current_character == "Player":
		position = player.global_position
	if !is_exploding and !is_joint_attacking:
		target = get_closest_enemy()
		
		if weakref(target).get_ref() != null and target and target.get_node("Area2D").overlaps_area($Detector):
			acceleration += seek()
			velocity += acceleration * delta
			velocity = velocity.clamped(SPEED)
		#	rotation = velocity.angle()
			position += velocity * delta
func get_closest_enemy():
	var enemies : Array = get_tree().get_nodes_in_group("EnemyEntity")
	var marked_enemies : Array = get_tree().get_nodes_in_group("MarkedWithSulphuricSigil")
	var target_enemy 
	if enemies.empty(): 
		return null
	else:
		if marked_enemies.empty():
			var distances : Array = []
			for enemy in enemies:
				var distance : float = player.global_position.distance_squared_to(enemy.global_position)
				distances.append(distance)
			var min_distance : float = distances.min()
			var min_index : int = distances.find(min_distance)
			target_enemy = enemies[min_index]
		else:
			var distances : Array = []
			for marked_enemy in marked_enemies:
				var distance : float = player.global_position.distance_squared_to(marked_enemy.global_position)
				distances.append(distance)
			var min_distance : float = distances.min()
			var min_index : int = distances.find(min_distance)
			target_enemy = marked_enemies[min_index]

	return target_enemy

func add_burning_stack():
	var enemy = get_overlapping_areas()
	for e in enemy:
		if e.is_in_group("Enemy"):
			if !e.is_in_group("Burnstack"):
				var burning_status = BURNING.instance()
				e.add_child(burning_status)

func _on_DestroyedTimer_timeout():
	if !is_joint_attacking:
		explode()
	else:
		yield(get_tree().create_timer($AnimationPlayer.get_animation("JointAttack").length), "timeout")
		joint_attack_points = 0 # so the player can't squeeze another joint attack when the timer expires. sorry!
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


func joint_attack():
	is_joint_attacking = true
	$AnimationPlayer.play("JointAttack")
	$MeterBar.value = $MeterBar.min_value
	
func end_joint_attack():
	is_joint_attacking = false

func add_meter_value(amount : int):
	if $MeterBar.value == $MeterBar.max_value:
		$AnimationPlayer.play("Flicker")
		$MeterBar.texture_progress = MAXED_ENERGY_METER
		joint_attack()
	else:
		if !is_joint_attacking:
			$MeterBar.value += amount

func _on_FireFairy_body_entered(body):
	if body.is_in_group("EnemyEntity") and !body.is_in_group("MarkedWithSulphuricSigil"):
		pass
#		var sigil = SULPHURIC_SIGIL.instance()
#		body.add_child(sigil)

	# handled with area2ds instead.
#	if body.is_in_group("IceBlockTileMap"):
#		var tilemap : TileMap = get_parent().get_node("IceBlockTileMap")
#
#		var cell = tilemap.world_to_map(body.get_position())
#		var tile_id : int = tilemap.get_cellv(cell)
#		print("entered tilemap " + str(cell))
#
#		if tile_id == 0:
#			tilemap.set_cellv(cell, 1)
#		if tile_id == 1:
#			tilemap.set_cellv(cell, -1)

func _on_FireFairy_area_entered(area):
	if area.is_in_group("Enemy"):
		add_burning_stack()
		emit_signal("add_mana_to_player", 0.15)
