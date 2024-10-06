extends CharacterBody2D

var health = 100

## dash vars
var dash_dist = 60

## shotgun vars
var shotgun_amount = 8
var shotgun_spread = PI / 2
var shotgun_spawn_radius = 0
var shotgun_speed = 100
var shotgun_acorn_chance = 0.1

## spinning ball vars
var spinning_ball_amount = 7
var spinning_ball_acorn_chance = 0.5
var spinning_ball_speed = 40
var spinning_ball_rot_speed = 50
var spinning_ball_spawn_dist = 0
var spinning_ball_radius = 30

## burst vars
var burst_amount = 8
var burst_acorn_chance = 0.1
var burst_speed = 100
var burst_spawn_dist = 0

## snipe vars
var snipe_speed = 400
var snipe_spawn_dist = 0

## frenzy vars
var frenzy_speed = 50
var frenzy_acorns_per_wave = 20
var frenzy_wave_num = 20
var frenzy_wave_cooldown = 0.5
var frenzy_spawn_dist = 0
var frenzy_turn = PI / 8

@onready var transformables = $Transformables
@onready var animp = $AnimationPlayer

@onready var nut_scene = preload("res://src/entities/boss/squirrel/squirrel_nut.tscn")
@onready var acorn_scene = preload("res://src/entities/boss/squirrel/squirrel_acorn.tscn")
@onready var nut_circle = preload("res://src/entities/boss/squirrel/nut_circle.tscn")

# -1 - idle
# 0 - jump
# 1 - dash
# 2 - shotgun
# 3 - spinning ball
# 4 - burst
# 5 - snipe
# 6 - frenzy
var state

var move_destination = Vector2.ZERO
var nut_bounces = 1
var last_slide_col : KinematicCollision2D = null

var idle_timer = 0
var idle_next_state = 0
var frenzy_wave_timer = 0
var frenzy_waves = 0
var frenzy_degree = 0

var has_frenzied = false

func _ready() -> void:
	switch_states(3)

func _physics_process(delta: float) -> void:
	physics_process_state(delta)
	move_and_slide()
	last_slide_col = get_last_slide_collision()
	$Label.text = str(state)

func physics_process_state(delta):
	match state:
		-1:
			idle_state_physics(delta)
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
			frenzy_state_physics(delta)

func switch_states(new_state):
	velocity = Vector2.ZERO
	if state:
		exit_state()
	state = new_state
	enter_state()

func enter_state():
	match state:
		-1:
			enter_idle_state()
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
	var stage_middle = Vector2(320,180) / 2
	var mid_vect = stage_middle - global_position
	mid_vect /= 6
	mid_vect = mid_vect * mid_vect * (mid_vect / abs(mid_vect))
	var player_vect = Singleton.player.global_position - global_position
	player_vect = (200 - player_vect.length()) * player_vect.normalized()
	var orth_vect = Vector2(player_vect.y, -player_vect.x).normalized()
	if randf() < 0.5:
		orth_vect = Vector2(-player_vect.y, player_vect.x).normalized()
	var move_vect = (mid_vect - player_vect + orth_vect * 75).normalized()
	move_destination = global_position + move_vect.normalized() * dash_dist
	global_position = move_destination

func shotgun_attack():
	var dir_vect = (Singleton.player.global_position - global_position).normalized()
	update_facing(dir_vect)
	var start_angle = dir_vect.angle() - shotgun_spread / 2 + shotgun_spread / shotgun_amount / 2
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
		get_parent().get_node("Projectiles").call_deferred("add_child", new_projectile)

func spinning_ball_attack():
	var dir_vect = (Singleton.player.global_position - global_position).normalized()
	update_facing(dir_vect)
	var new_spinning_ball = nut_circle.instantiate()
	new_spinning_ball.spawn_acorn = randf() < spinning_ball_acorn_chance
	new_spinning_ball.nut_num = spinning_ball_amount
	new_spinning_ball.rotation_speed = spinning_ball_rot_speed
	new_spinning_ball.speed = spinning_ball_speed
	new_spinning_ball.dir = dir_vect
	new_spinning_ball.radius = spinning_ball_radius
	new_spinning_ball.bounces = nut_bounces
	new_spinning_ball.global_position = global_position + dir_vect * spinning_ball_spawn_dist
	get_parent().get_node("Projectiles").call_deferred("add_child", new_spinning_ball)

func burst_attack():
	var angle_inc = TAU / burst_amount
	var start_angle = randf_range(0, angle_inc)
	for i in range(burst_amount):
		var dir_vect = Vector2.from_angle(start_angle + angle_inc * i)
		var new_projectile
		if randf() < burst_acorn_chance:
			new_projectile = acorn_scene.instantiate()
		else:
			new_projectile = nut_scene.instantiate()
			new_projectile.bounces = nut_bounces
		new_projectile.dir = dir_vect
		new_projectile.speed = burst_speed
		new_projectile.global_position = global_position + burst_spawn_dist * dir_vect
		get_parent().get_node("Projectiles").call_deferred("add_child", new_projectile)

func snipe_attack():
	var dir_vect = (Singleton.player.global_position - global_position).normalized()
	update_facing(dir_vect)
	var new_acorn = acorn_scene.instantiate()
	new_acorn.dir = dir_vect
	new_acorn.speed = snipe_speed
	new_acorn.global_position = global_position + dir_vect * snipe_spawn_dist
	get_parent().get_node("Projectiles").call_deferred("add_child", new_acorn)

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
		get_parent().get_node("Projectiles").call_deferred("add_child", new_nut)

func idle(time):
	idle_timer = time
	switch_states(-1)

func upgrade_stats():
	pass

## PHYSICS FUNCTIONS

func idle_state_physics(delta):
	idle_timer -= delta
	if idle_timer <= 0:
		check_switch_idle_state()

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

func frenzy_state_physics(delta):
	if frenzy_wave_timer <= 0:
		spawn_frenzy_wave()
		frenzy_degree -= frenzy_turn
		frenzy_waves -= 1
		frenzy_wave_timer = frenzy_wave_cooldown
		if frenzy_waves == 0:
			check_switch_frenzy_state()
		print(frenzy_waves)
	frenzy_wave_timer -= delta

## ENTER STATE FUNCTIONS

func enter_idle_state():
	animp.play("idle")

func enter_jump_state():
	animp.play("jump")

func enter_dash_state():
	animp.play("dash")
	dash_move()

func enter_shotgun_state():
	animp.play("shotgun")
	shotgun_attack()

func enter_spinning_ball_state():
	animp.play("spinning_ball")
	spinning_ball_attack()

func enter_burst_state():
	animp.play("burst")
	burst_attack()

func enter_snipe_state():
	animp.play("snipe")
	snipe_attack()

func enter_frenzy_state():
	animp.play("frenzy")
	frenzy_waves = frenzy_wave_num

## EXIT STATE FUNCTIONS

func exit_jump_state():
	pass

func exit_dash_state():
	pass

func exit_shotgun_state():
	pass

func exit_spinning_ball_state():
	pass

func exit_burst_state():
	pass

func exit_snipe_state():
	pass

func exit_frenzy_state():
	upgrade_stats()

## SWITCH STATE FUNCTIONS

func check_switch_idle_state():
	switch_states(idle_next_state)

func check_switch_jump_state():
	idle_next_state = 6
	idle(1)

func check_switch_dash_state():
	var p = randf()
	if p < 0.2:
		idle_next_state = 1
	elif p < 0.6:
		idle_next_state = 2
	elif p < 0.8:
		idle_next_state = 3
	else:
		idle_next_state = 4
	idle(1)

func check_switch_shotgun_state():
	var p = randf()
	if p < 0.8:
		idle_next_state = 1
	else:
		idle_next_state = 5
	idle(1)

func check_switch_spinning_ball_state():
	var p = randf()
	if p < 0.6:
		idle_next_state = 1
	elif p < 0.8:
		idle_next_state = 2
	else:
		idle_next_state = 5
	idle(1)

func check_switch_burst_state():
	var p = randf()
	if p < 0.4:
		idle_next_state = 1
	elif p < 0.7:
		idle_next_state = 2
	else:
		idle_next_state = 5
	idle(1)

func check_switch_snipe_state():
	idle_next_state = 1
	idle(1)

func check_switch_frenzy_state():
	idle_next_state = 5
	idle(1)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"idle":
			pass
		"jump":
			check_switch_jump_state()
		"dash":
			check_switch_dash_state()
		"shotgun":
			check_switch_shotgun_state()
		"spinning_ball":
			check_switch_spinning_ball_state()
		"burst":
			check_switch_burst_state()
		"snipe":
			check_switch_snipe_state()
		"frenzy":
			pass
