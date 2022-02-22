class_name Elevator extends KinematicBody2D

enum dir { UP, DOWN }
export (dir) var direction
export (int) var Time
var velocity = Vector2()
var Speed : int = 1000 # 600
var moving : bool = false
onready var closed = preload("res://assets/terrain/elevator_closed.png")
onready var opened = preload("res://assets/terrain/elevator_opened.png")
onready var player = get_parent().get_node("Player").get_node("Area2D")

func _ready():
	$Timer.wait_time = Time
	open()

func close():
	$Sprite.texture = closed
	$LeftBarrier/CollisionShape2D.disabled = false
	$RightBarrier/CollisionShape2D.disabled = false
	$TopBarrier/CollisionShape2D.disabled = false

func open():
	$Sprite.texture = opened
	$LeftBarrier/CollisionShape2D.disabled = true
	$RightBarrier/CollisionShape2D.disabled = true
	$TopBarrier/CollisionShape2D.disabled = true

func _physics_process(delta):
	if $Detector.overlaps_area(player):
		if velocity.y == 0:
			open()
		yield(get_tree().create_timer(0.75), "timeout")
		if direction == dir.UP:
			if $Timer.is_stopped():
				$Timer.start()
				moving = true
			if moving:
				close()
				velocity.y = -Speed 
				velocity.x = 0
				velocity = move_and_slide(velocity)
		elif direction == dir.DOWN:
			if $Timer.is_stopped():
				$Timer.start()
				moving = true
			if moving:
				close()
				velocity.y = Speed 
				velocity.x = 0
				velocity = move_and_slide(velocity)


func _on_Timer_timeout():
	moving = false
	velocity.y = 0
	open()
