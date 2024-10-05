extends CharacterBody2D

@onready var nut_scene = preload("res://src/entities/boss/squirrel/squirrel_nut.tscn")
@onready var acorn_scene = preload("res://src/entities/boss/squirrel/squirrel_acorn.tscn")

var spawn_acorn = true
var acorn_num = 20
var rotation_speed = 100
var radius = 100
var speed = 10
var dir = Vector2.RIGHT
var clockwise = true

var acorn = null

var nuts = []

func _ready() -> void:
	global_position = Vector2(320/2,180/2)
	var angle_inc = TAU / acorn_num
	var start_angle = randf_range(0, angle_inc)
	for i in range(acorn_num):
		var cur_angle = start_angle + i * angle_inc
		var spawn_pos = global_position + Vector2.RIGHT.rotated(cur_angle) * radius
		var new_nut = nut_scene.instantiate()
		new_nut.dir = Vector2.RIGHT
		new_nut.global_position = spawn_pos
		new_nut.speed = rotation_speed
		new_nut.locked = true
		nuts.append(new_nut)
		add_child(new_nut)
	
	if spawn_acorn:
		var new_acorn = acorn_scene.instantiate()
		new_acorn.global_position = global_position
		new_acorn.speed = speed
		new_acorn.dir = dir
		add_child(new_acorn)

func _physics_process(delta: float) -> void:
	velocity = dir * speed
	move_and_slide()
	for nut in nuts:
		if not nut or not nut.locked:
			nuts.erase(nut)
			if not nuts:
				queue_free()
		nut.velocity = velocity
		nut.move_and_slide()
		var nut_vect = (nut.global_position - global_position).normalized()
		nut.dir = Vector2(-nut_vect.y, nut_vect.x) if clockwise else Vector2(nut_vect.y, -nut_vect.x)
		nut.global_position += nut_vect * (radius - (nut.global_position - global_position).length())
