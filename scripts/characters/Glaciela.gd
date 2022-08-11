class_name Glaciela extends Node2D

const SWORD_SLASH_EFFECT : PackedScene = preload("res://scenes/particles/SwordSlashEffect.tscn")
const SWORD_HIT_PARTICLE : PackedScene = preload("res://scenes/particles/SwordHitParticle.tscn")
const AIRBORNE_STATUS : PackedScene = preload("res://scenes/status_effects/AirborneStatus.tscn")
signal skill_used()
signal life_changed(amount)
var target

func _ready():
	connect("life_changed", get_parent().get_parent().get_node("HeartUI/Life"), "on_player_hearts_changed")
	$AnimatedSprite.play("Default")
	$SpearSprite.visible = false
	$AttackCollision.add_to_group(str(Global.glaciela_attack))


func _physics_process(delta):
	target = get_closest_enemy()
	if Global.current_character == "Glaciela":

		# Animation handling 
		if Input.is_action_pressed("left") and !get_parent().get_parent().is_attacking and !get_parent().get_parent().is_dashing and !get_parent().get_parent().is_knocked_back:
			$AnimatedSprite.flip_h = true
		elif Input.is_action_pressed("right") and !get_parent().get_parent().is_attacking and !get_parent().get_parent().is_dashing and !get_parent().get_parent().is_knocked_back:
			$AnimatedSprite.flip_h = false
		if Input.is_action_just_pressed("ui_dash") and !get_parent().get_parent().can_dash and !get_parent().get_parent().get_node("DashUseTimer").is_stopped():
			$AnimatedSprite.play("Dash")
			yield(get_tree().create_timer(0.25), "timeout")
			$AnimatedSprite.play("Default")
		
		if Input.is_action_just_pressed("ui_attack") and $MeleeTimer.is_stopped():
			if !$AnimatedSprite.flip_h:
				$SpearSprite.visible = true
				$AnimationPlayer.play("SpearSwingRight")
				$AttackCollision/CollisionShape2D.disabled = false
				get_parent().get_parent().attack_knock()
				get_node("AttackCollision").set_scale(Vector2(1,1))
				$MeleeTimer.start()
			else:
				$SpearSprite.visible = true
				$AnimationPlayer.play("SpearSwingLeft")
				$AttackCollision/CollisionShape2D.disabled = false
				get_parent().get_parent().attack_knock()
				get_node("AttackCollision").set_scale(Vector2(-1,1))
				$MeleeTimer.start()
		
		if get_parent().get_parent().get_node("ChargeBar").value == get_parent().get_parent().get_node("ChargeBar").max_value:
			if Input.is_action_just_pressed("ui_attack") and Global.mana >= 2:
				if target and target.get_node("Area2D").overlaps_area($ChargedAttackCollision):
					$AnimationPlayer.play("ChargedAttackRight")
					var airborne_status = AIRBORNE_STATUS.instance()
					target.add_child(airborne_status)

		if Input.is_action_just_pressed("primary_skill") and !Input.is_action_just_pressed("secondary_skill"):
			emit_signal("skill_used")



func get_closest_enemy():
	var enemies = get_tree().get_nodes_in_group("Enemy")
	if enemies.empty(): 
		return null
	var distances = []
	for enemy in enemies:
		var distance = get_parent().get_parent().global_position.distance_squared_to(enemy.global_position)
		distances.append(distance)
	var min_distance = distances.min()
	var min_index = distances.find(min_distance)
	var closest_enemy = enemies[min_index]
	return closest_enemy
	
func set_weapon_to_invisible():
	$SpearSprite.visible = false


func _on_AttackCollision_area_entered(area):
	if area.is_in_group("Enemy") or area.is_in_group("Enemy2"):
		var hitparticle = SWORD_HIT_PARTICLE.instance()
		var slashparticle = SWORD_SLASH_EFFECT.instance()
		hitparticle.emitting = true
		get_parent().get_parent().get_parent().add_child(hitparticle)
		get_parent().get_parent().get_parent().add_child(slashparticle)
		hitparticle.position = get_parent().get_parent().get_node("Position2D").global_position
		slashparticle.position = get_parent().get_parent().get_node("Position2D").global_position


func _on_MeleeTimer_timeout():
	$AttackCollision/CollisionShape2D.disabled = true
