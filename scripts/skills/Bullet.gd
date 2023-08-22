class_name Bullet extends Node2D

# change back later to get_parent().get_node("Player")
onready var player = get_node("BulletSprite")
var velocity = Vector2()
const SPEED = 15
var y_angle 





func _ready():
	if weakref(get_closest_enemy()).get_ref() != null:
		if get_closest_enemy().global_position.y >= self.global_position.y:
			y_angle = deg2rad(calculate_rotation_angle())
			$BulletSprite.rotation_degrees = calculate_rotation_angle()
		else:
			y_angle = deg2rad(-calculate_rotation_angle())
			$BulletSprite.rotation_degrees = -calculate_rotation_angle()
		
func _physics_process(delta):
	velocity.x = SPEED
	velocity.y = SPEED * y_angle
	translate(velocity)
	
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
	

func calculate_rotation_angle():
	if weakref(get_closest_enemy()) != null:
		var self_coordinate = player.global_position
		var enemy_coordinate = get_closest_enemy().global_position
		var right_angle_coordinate = Vector2(enemy_coordinate.x, self_coordinate.y)
		var adjacent = self_coordinate.distance_to(right_angle_coordinate)
		var hypotenuse = self_coordinate.distance_to(enemy_coordinate)
		return rad2deg(acos(adjacent / hypotenuse))
		
		

