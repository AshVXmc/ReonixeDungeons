class_name MusicNoteAttack extends Node2D

var SPEED : int = 750
onready var eighth_note = preload("res://assets/characters/lysandra/eighth_note.png")
onready var single_note = preload("res://assets/characters/lysandra/single_note.png")
var velocity = Vector2()
var direction : int = 1
var destroyed : bool = false


func _physics_process(delta):
	velocity.x = SPEED * delta * direction
	translate(velocity)
