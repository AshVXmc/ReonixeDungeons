class_name Glaciela extends Node2D

const SWORD_SLASH_EFFECT : PackedScene = preload("res://scenes/particles/SwordSlashEffect.tscn")
const SWORD_HIT_PARTICLE : PackedScene = preload("res://scenes/particles/SwordHitParticle.tscn")
const AIRBORNE_STATUS : PackedScene = preload("res://scenes/status_effects/AirborneStatus.tscn")
signal skill_used(skill_name)
signal life_changed(amount)
var target

func _ready():
	connect("life_changed", get_parent().get_parent().get_parent().get_node("HeartUI/Life"), "on_player_life_changed")
	connect("skill_used", get_parent().get_parent().get_parent().get_node("SkillsUI/Control"), "on_skill_used")
	connect("skill_used", get_parent().get_parent().get_node("SkillManager"), "on_skill_used")
	$AnimatedSprite.play("Default")
	$SpearSprite.visible = false
	$AttackCollision.add_to_group(str(Global.glaciela_attack))
	


func _physics_process(delta):
	target = get_closest_enemy()
	
	if Global.current_character == "Glaciela":
		$AnimatedSprite.visible = true
		# Animation handling 
		if Input.is_action_pressed("left") and !get_parent().get_parent().is_attacking and !get_parent().get_parent().is_dashing and !get_parent().get_parent().is_knocked_back:
			$AnimatedSprite.flip_h = true
			$AnimatedSprite.play("Walk")
		elif Input.is_action_pressed("right") and !get_parent().get_parent().is_attacking and !get_parent().get_parent().is_dashing and !get_parent().get_parent().is_knocked_back:
			$AnimatedSprite.flip_h = false
			$AnimatedSprite.play("Walk")
		
		if get_parent().get_parent().can_dash:
			if Input.is_action_pressed("left") or Input.is_action_pressed("right") and !Input.is_action_pressed("jump"):
				$AnimatedSprite.play("Walk")
			else:
				$AnimatedSprite.play("Default")
		if Input.is_action_just_pressed("ui_dash") and !get_parent().get_parent().can_dash and !get_parent().get_parent().get_node("DashUseTimer").is_stopped():
			$AnimatedSprite.play("Dash")
			yield(get_tree().create_timer(0.25), "timeout")
			$AnimatedSprite.play("Default")
		
		if Input.is_action_just_pressed("jump"):
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
				if target and target.get_node("Area2D").overlaps_area($ChargedAttackCollision) or target.get_node("Area2D").overlaps_area($ChargedAttackCollision2):
					$AnimationPlayer.play("ChargedAttackRight")
					var airborne_status = AIRBORNE_STATUS.instance()
					target.add_child(airborne_status)

		if Input.is_action_just_pressed("primary_skill") and !Input.is_action_just_pressed("secondary_skill"):
			print("skill emitted")
			emit_signal("skill_used", "IceLance")



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


func _on_Area2D_area_entered(area):
	if Global.current_character == "Glaciela":
		if area.is_in_group("HealthPot"):
			Global.healthpot_amount += 1
			emit_signal("healthpot_obtained", Global.healthpot_amount)
		if area.is_in_group("LifeWine"):
			Global.lifewine_amount += 1
			emit_signal("lifewine_obtained", Global.lifewine_amount)
		if !Global.godmode:
			if get_parent().get_parent().inv_timer.is_stopped() and !get_parent().get_parent().is_invulnerable and !get_parent().get_parent().is_dashing:
				if area.is_in_group("Enemy") or area.is_in_group("DeflectedProjectile"):
					
					if Global.current_character == Global.equipped_characters[0]:
						Global.hearts -= 1
						get_parent().get_parent().add_hurt_particles(0.5)
						take_damage(1, Global.hearts)
					elif Global.current_character == Global.equipped_characters[1]:
						Global.character2_hearts -= 1
						# This gets called twice when the character takes damage for the first time for some reason
						print(Global.character2_hearts)
						get_parent().get_parent().add_hurt_particles(0.5)
						take_damage(1, Global.character2_hearts)
					elif Global.current_character == Global.equipped_characters[2]:
						Global.character3_hearts -= 1
						get_parent().get_parent().add_hurt_particles(0.5)
						take_damage(1, Global.character3_hearts)
							
					get_parent().get_parent().is_gliding = false
					Input.action_release("charge")
					get_parent().get_parent().afterDamaged()
					if !area.is_in_group("LightEnemy"):
						get_parent().get_parent().knockback()
					get_parent().get_parent().get_node("CampfireTimer").stop()
				if area.is_in_group("Enemy2"):
					Global.hearts -= 1
					get_parent().get_parent().add_hurt_particles(1)
					get_parent().get_parent().is_gliding = false
					Input.action_release("charge")
					get_parent().get_parent().afterDamaged()
					get_parent().get_parent().knockback()
					get_parent().get_parent().get_node("CampfireTimer").stop()
			if area.is_in_group("Spike"):
				Global.hearts -= 0.5
				Input.action_release("charge")
				get_parent().get_parent().afterDamaged()
				get_parent().get_parent().get_node("CampfireTimer").stop()
		if area.is_in_group("SlowingPoison"):
			get_parent().get_parent().slow_player(2.0)
		if area.is_in_group("Transporter"):
			get_parent().get_parent().emit_signal("level_changed")
#	if area.is_in_group("Enemy") and !get_parent().get_parent().is_invulnerable:
#		$AnimationPlayer.play("Hurt")

func take_damage(damage : float, hearts):
	if Global.current_character == "Glaciela":
		hearts -= damage
		print(hearts)
		emit_signal("life_changed", hearts , "Glaciela")
		print("TAKEN DAMAGE")



