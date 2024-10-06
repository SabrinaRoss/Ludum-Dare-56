extends CharacterBody2D

var health = 100

## shotgun vars
var shotgun_amount = 5
var shotgun_spread = PI
var shotgun_spawn_radius = 10
var shotgun_speed = 100
var shotgun_acorn_chance = 0.1

## spinning ball vars
var spinning_ball_amount = 10
var spinning_ball_acorn_chance = 0.5
var spinning_ball_speed = 40
var spinning_ball_rot_speed = 100
var spinning_ball_spawn_dist = 10

## snipe vars
var snipe_speed = 200
var snipe_spawn_dist = 10

## frenzy vars
var frenzy_speed = 50
var frenzy_acorns_per_wave = 3
var frenzy_wave_num = 20
var frenzy_wave_cooldown = 0.5
var frenzy_spawn_dist = 10
var frenzy_turn = PI / 8

@onready var transformables = $Transformables

@onready var nut_scene = preload("res://src/entities/boss/squirrel/squirrel_nut.tscn")
@onready var acorn_scene = preload("res://src/entities/boss/squirrel/squirrel_acorn.tscn")
@onready var nut_circle = preload("res://src/entities/boss/squirrel/nut_circle.tscn")

# 0 - jump
# 1 - dash
# 2 - shotgun
# 3 - spinning ball
# 4 - burst
# 5 - snipe
# 6 - frenzy
var state

var jump_destination = Vector2.ZERO
var nut_bounces = 0
var last_slide_col : KinematicCollision2D = null

var rest_timer = 0
var frenzy_wave_timer = 0
var frenzy_waves = 0
var frenzy_degree = 0

func _ready() -> void:
	switch_states(0)

func _physics_process(delta: float) -> void:
	if rest_timer <= 0:
		physics_process_state()
		check_switch_state()
	move_and_slide()
	last_slide_col = get_last_slide_collision()

func physics_process_state():
	match state:
		0:
			jump_state_physics()
		1:
			dash_state_physics()
		2:
			shotgun_state_physics()
		3:
			spinning_ball_state_physics()
		4:
			burst_state_physics()
		5:
			snipe_state_physics()
		6:
			frenzy_state_physics()

func switch_states(new_state):
	if state:
		exit_state()
	state = new_state
	enter_state()

func enter_state():
	match state:
		0:
			enter_jump_state()
		1:
			enter_dash_state()
		2:
			enter_shotgun_state()
		3:
			enter_spinning_ball_state()
		4:
			enter_burst_state()
		5:
			enter_snipe_state()
		6:
			enter_frenzy_state()

func exit_state():
	match state:
		0:
			exit_jump_state()
		1:
			exit_dash_state()
		2:
			exit_shotgun_state()
		3:
			exit_spinning_ball_state()
		4:
			exit_burst_state()
		5:
			exit_snipe_state()
		6:
			exit_frenzy_state()

func check_switch_state():
	match state:
		0:
			check_switch_jump_state()
		1:
			check_switch_dash_state()
		2:
			check_switch_shotgun_state()
		3:
			check_switch_spinning_ball_state()
		4:
			check_switch_burst_state()
		5:
			check_switch_snipe_state()
		6:
			check_switch_frenzy_state()

func update_facing(dir : Vector2):
	if dir.dot(Vector2.RIGHT) < 0:
		transformables.scale.x = -1
	else:
		transformables.scale.x = 1

func dash_move():
	pass

func shotgun_attack():
	var dir_vect = (Singleton.player.global_position - global_position).normalized()
	update_facing(dir_vect)
	var start_angle = dir_vect.angle() - shotgun_spread / 2
	for i in range(shotgun_amount):
		var cur_dir = Vector2.RIGHT.rotated(start_angle + i * shotgun_spread / shotgun_amount)
		var new_projectile
		if randf() < shotgun_acorn_chance:
			new_projectile = acorn_scene.instantiate()
		else:
			new_projectile = nut_scene.instantiate()
			new_projectile.bounces = nut_bounces
		new_projectile.global_position = global_position + cur_dir * shotgun_spawn_radius
		new_projectile.dir = cur_dir
		new_projectile.speed = shotgun_speed
		add_child(new_projectile)

func spinning_ball_attack():
	var dir_vect = (Singleton.player.global_position - global_position).normalized()
	update_facing(dir_vect)
	var new_spinning_ball = nut_circle.instantiate()
	new_spinning_ball.spawn_acorn = randf() < spinning_ball_acorn_chance
	new_spinning_ball.nut_num = spinning_ball_amount
	new_spinning_ball.rotation_speed = spinning_ball_rot_speed
	new_spinning_ball.speed = spinning_ball_speed
	new_spinning_ball.dir = dir_vect
	new_spinning_ball.global_position = global_position + dir_vect * spinning_ball_spawn_dist
	add_child(new_spinning_ball)

func snipe_attack():
	var dir_vect = (Singleton.player.global_position - global_position).normalized()
	update_facing(dir_vect)
	var new_acorn = acorn_scene.instantiate()
	new_acorn.dir = dir_vect
	new_acorn.speed = snipe_speed
	new_acorn.global_position = global_position + dir_vect * snipe_spawn_dist
	add_child(new_acorn)

func spawn_frenzy_wave():
	var start_angle = frenzy_degree
	var angle_inc = TAU / frenzy_acorns_per_wave
	for i in frenzy_acorns_per_wave:
		var ang = start_angle + angle_inc * i
		var nut_dir = Vector2.RIGHT.rotated(ang)
		var new_nut = nut_scene.instantiate()
		new_nut.dir = nut_dir
		new_nut.speed = frenzy_speed
		new_nut.bounces = nut_bounces
		new_nut.global_position = global_position + nut_dir * frenzy_spawn_dist
		add_child(new_nut)

func idle(time):
	pass

func upgrade_stats():
	pass

func norm_pick_state() -> int:
	return 0

## PHYSICS FUNCTIONS

func jump_state_physics():
	pass

func dash_state_physics():
	pass

func shotgun_state_physics():
	pass

func spinning_ball_state_physics():
	pass

func burst_state_physics():
	pass

func snipe_state_physics():
	pass

func frenzy_state_physics():
	if frenzy_wave_timer <= 0:
		spawn_frenzy_wave()
		frenzy_degree -= frenzy_turn
		frenzy_waves -= 1
		frenzy_wave_timer = frenzy_wave_cooldown
		if frenzy_waves == 0:
			switch_states(norm_pick_state())

## ENTER STATE FUNCTIONS

func enter_jump_state():
	pass

func enter_dash_state():
	pass

func enter_shotgun_state():
	pass

func enter_spinning_ball_state():
	pass

func enter_burst_state():
	pass

func enter_snipe_state():
	pass

func enter_frenzy_state():
	pass

## EXIT STATE FUNCTIONS

func exit_jump_state():
	idle(1)

func exit_dash_state():
	idle(1)

func exit_shotgun_state():
	idle(1)

func exit_spinning_ball_state():
	idle(1)

func exit_burst_state():
	idle(1)

func exit_snipe_state():
	idle(1)

func exit_frenzy_state():
	upgrade_stats()
	idle(1)

## SWITCH STATE FUNCTIONS

func check_switch_jump_state():
	pass

func check_switch_dash_state():
	pass

func check_switch_shotgun_state():
	pass

func check_switch_spinning_ball_state():
	pass

func check_switch_burst_state():
	pass

func check_switch_snipe_state():
	pass

func check_switch_frenzy_state():
	pass
