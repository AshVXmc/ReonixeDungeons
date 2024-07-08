class_name ShamanGoblin extends Goblin

const HEALING_ORB : PackedScene = preload("res://scenes/enemies/EnemyHealingOrb.tscn")
const TELEPORT_ANCHOR : PackedScene = preload("res://scenes/enemies/EnemyTeleportAnchor.tscn")
var target
var is_in_range : bool = false
var casting_healing : bool = false
onready var player = get_parent().get_node("Player/Area2D")
onready var tp_anchor_name : String = "Anchor" + name

func _ready():
	# Overrides
	MAX_SPEED = MAX_SPEED / 3 * -1
	SPEED = MAX_SPEED
	$HealingOrbTimer.start()

	
class InjuredEnemySorter:
	static func sort_by_injury(hp1, hp2):
		if hp1[0] < hp2[0]:
			return true
		return false

func get_closest_injured_enemy():
	var enemies = get_tree().get_nodes_in_group("CanBeHealed")
	var injured_enemies = []
	for enemy in enemies:
		if enemy.HP < enemy.max_HP:
			injured_enemies.append([enemy.HP, enemy])
	injured_enemies.sort_custom(InjuredEnemySorter, "sort_by_injury")
	if enemies.empty() or injured_enemies.empty(): 
		return null
	var most_injured_enemy = injured_enemies[0][1]
	return most_injured_enemy


func _process(delta):
	if casting_healing:
		SPEED = 0
	else:
		SPEED = MAX_SPEED / 2.5
	target = get_closest_injured_enemy()
#func _physics_process(delta):
#		pass
	
	
func summon_healing_orb():
	casting_healing = true
	$CastingParticle.visible = true
	yield(get_tree().create_timer(0.65), "timeout")
	var heal_orb = HEALING_ORB.instance()
	heal_orb.target = target
	get_parent().add_child(heal_orb)
	if !$Sprite.flip_h:
		heal_orb.position = $StaffSkullPosition2DLeft.global_position
	else:
		heal_orb.position = $StaffSkullPosition2DRight.global_position
	$CastingParticle.visible = false
	casting_healing = false
	$HealingOrbTimer.start()

func _on_HealingOrbTimer_timeout():
	if !is_frozen and target != null and target.get_node("Area2D").overlaps_area($Detector):
		summon_healing_orb()
	else:
		$HealingOrbTimer.start()

func teleport_away():
	is_casting = true
	$TeleportSpellCooldownTimer.start()
	$TeleportParticles.emitting = true
	$TeleportParticles.one_shot = true
	var anchor = TELEPORT_ANCHOR.instance()
	var anchor_secondary = TELEPORT_ANCHOR.instance()
	get_parent().get_parent().add_child(anchor)
	get_parent().get_parent().add_child(anchor_secondary)
	if !$Sprite.flip_h:
		anchor.x_direction = 1
		anchor_secondary.x_direction = -1
	else:
		anchor.x_direction = -1
		anchor_secondary.x_direction = 1
	anchor.position = global_position
	anchor_secondary.position = global_position
	
	yield(get_tree().create_timer(0.6), "timeout")
#	print("range: " + str(position.distance_to(anchor.global_position)))
	var teleport_destination : Vector2 
	if position.distance_to(anchor.global_position) >= (position.distance_to(anchor_secondary.global_position) / 2):
		teleport_destination = anchor.global_position
		anchor.get_node("TeleportParticles").emitting = true
	else:
		teleport_destination = anchor_secondary.global_position
		anchor_secondary.get_node("TeleportParticles").emitting = true
	yield(get_tree().create_timer(0.4), "timeout")
	position.x = teleport_destination.x
	position.y = teleport_destination.y 
	anchor.destroy_anchor()
	anchor_secondary.destroy_anchor()

	is_casting = false
	

func _on_PlayerDetectorArea2D_area_entered(area):
	if !is_frozen and area.is_in_group("Player") and $TeleportSpellCooldownTimer.is_stopped():
		teleport_away()
