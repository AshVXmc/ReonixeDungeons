class_name ShamanGoblin extends Goblin

const HEALING_ORB : PackedScene = preload("res://scenes/enemies/EnemyHealingOrb.tscn")
var target
var is_in_range : bool = false
var casting_healing : bool = false


func _ready():
	# Overrides
	max_HP = 15 + (Global.enemy_level_index * 15)
	SPEED = MAX_SPEED / 2.5
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

func _physics_process(delta):
	if casting_healing:
		SPEED = 0
	else:
		SPEED = MAX_SPEED / 2.5
	target = get_closest_injured_enemy()

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
	if target != null and target.get_node("Area2D").overlaps_area($Detector):
		summon_healing_orb()
	else:
		$HealingOrbTimer.start()
