extends CharacterBody2D

var max_health = 100

var collision_damage = 10

## jump speed
var jump_speed = 100

## dash vars
var dash_dist = 60
var dash_speed = 150

## shotgun vars
var shotgun_amount = 6
var shotgun_spread = PI / 2
var shotgun_spawn_radius = 2
var shotgun_speed = 150
var shotgun_acorn_chance = 0.05
var shotgun_speed_change = 60

## spinning ball vars
var spinning_ball_amount = 6
var spinning_ball_acorn_chance = 1
var spinning_ball_speed = 100
var spinning_ball_rot_speed = 40
var spinning_ball_spawn_dist = 2
var spinning_ball_radius = 60

## burst vars
var burst_amount = 12
var burst_acorn_chance = 0.1
var burst_speed = 125
var burst_spawn_dist = 2

## snipe vars
var snipe_speed = 300
var snipe_spawn_dist = 2

## frenzy vars
var frenzy_speed = 75
var frenzy_acorns_per_wave = 8
var frenzy_wave_num = 60
var frenzy_wave_cooldown = 0.2
var frenzy_spawn_dist = 2
var frenzy_turn = PI / 32

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
var nut_bounces = 0
var last_slide_col : KinematicCollision2D = null

var idle_timer = 0
var idle_next_state = 0
var frenzy_wave_timer = 0
var frenzy_waves = 0
var frenzy_degree = 0
var jump_starting = false
var jump_start_dist = 0
var health = 1
var idle_mult = 1

var has_frenzied = false

func _ready() -> void:
	health = max_health
	switch_states(3)

func _physics_process(delta: float) -> void:
	physics_process_state(delta)
	move_and_slide()
	last_slide_col = get_last_slide_collision()
	if last_slide_col:
		var col_dir = (last_slide_col.get_position() - global_position).normalized()
		if col_dir.dot(move_destination - global_position) > 0:
			move_destination = global_position

func take_damage(damage):
	health -= damage
	$Sound/hurt.play()
	if health <= 0:
		death()

func death():
	Singleton.main.bossDeath()

func deal_collision_damage(area : Area2D):
	var target = area.owner
	target.take_damage(collision_damage)

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
	if health <= max_health / 2. and not has_frenzied and state != -1:
		has_frenzied = true
		switch_states(0)
		return
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

func jump_sound():
	$Sound/jump.pitch_scale = randf_range(1.9, 2.1)
	$Sound/jump.play()

func throw_sound():
	$Sound/jump.pitch_scale = randf_range(.9, 1.1)
	$Sound/jump.play()

func update_facing(dir : Vector2):
	if dir.dot(Vector2.RIGHT) < 0:
		transformables.scale.x = 1
	else:
		transformables.scale.x = -1

func dash_move():
	var stage_middle = Vector2.ZERO
	var mid_vect : Vector2 = stage_middle - global_position
	mid_vect /= 6
	mid_vect = mid_vect.length_squared() * mid_vect.normalized()
	print(mid_vect)
	var player_vect = Singleton.player.global_position - global_position
	player_vect = (200 - player_vect.length()) * player_vect.normalized()
	var orth_vect = Vector2(player_vect.y, -player_vect.x).normalized()
	if randf() < 0.5:
		orth_vect = Vector2(-player_vect.y, player_vect.x).normalized()
	var move_vect = (mid_vect - player_vect + orth_vect * 75).normalized()
	move_destination = global_position + move_vect.normalized() * dash_dist
	update_facing(move_vect)

func shotgun_attack():
	var dir_vect = (Singleton.player.global_position - global_position).normalized()
	update_facing(dir_vect)
	throw_sound()
	for i in range(shotgun_amount):
		var cur_dir = dir_vect.rotated(randf_range(-shotgun_spread/2, shotgun_spread/2))
		var new_projectile
		if randf() < shotgun_acorn_chance:
			new_projectile = acorn_scene.instantiate()
		else:
			new_projectile = nut_scene.instantiate()
			new_projectile.bounces = nut_bounces
		new_projectile.global_position = global_position + cur_dir * shotgun_spawn_radius
		new_projectile.dir = cur_dir
		new_projectile.speed = shotgun_speed + randf_range(-shotgun_speed_change/2., shotgun_speed_change/2.)
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
	await get_tree().create_timer(1 * idle_mult).timeout
	new_spinning_ball.still = false
	throw_sound()

func burst_attack():
	var angle_inc = TAU / burst_amount
	var start_angle = randf_range(0, angle_inc)
	throw_sound()
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
	throw_sound()
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
	idle_timer = time * idle_mult
	switch_states(-1)

func move_to(speed):
	var dir_vect = (move_destination - global_position).normalized()
	velocity = dir_vect * speed

func upgrade_stats():
	nut_bounces = 1
	idle_mult = 0.5

## PHYSICS FUNCTIONS

func idle_state_physics(delta):
	idle_timer -= delta
	if idle_timer <= 0:
		check_switch_idle_state()

func jump_state_physics():
	if not jump_starting:
		move_to(jump_speed)
		
		if (move_destination - global_position).length() < jump_start_dist / 2.:
			animp.play("jump_land")
		
		if (move_destination - global_position).length() < 10:
			check_switch_jump_state()

func dash_state_physics():
	#move_to(dash_speed)
	#if (move_destination - global_position).length() < 10:
		#check_switch_dash_state()
	
	if not jump_starting:
		move_to(dash_speed)
		
		if (move_destination - global_position).length() < dash_dist / 2.:
			animp.play("jump_land")
		
		if (move_destination - global_position).length() < 10:
			check_switch_dash_state()

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
	frenzy_wave_timer -= delta

## ENTER STATE FUNCTIONS

func enter_idle_state():
	animp.play("idle")

func enter_jump_state():
	Singleton.main.phase_change()
	animp.play("jump_start")
	jump_sound()
	jump_starting = true
	move_destination = Vector2.ZERO
	update_facing((move_destination - global_position).normalized())
	jump_start_dist = (move_destination - global_position).length()

func enter_dash_state():
	#animp.play("dash")
	#dash_move()
	
	animp.play("jump_start")
	jump_starting = true

func enter_shotgun_state():
	animp.play("shotgun")

func enter_spinning_ball_state():
	animp.play("spinning_ball")

func enter_burst_state():
	animp.play("burst")

func enter_snipe_state():
	animp.play("snipe")

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
	idle(0.5)

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
	idle(0.1)

func check_switch_shotgun_state():
	var p = randf()
	if p < 0.8:
		idle_next_state = 1
	else:
		idle_next_state = 5
	idle(0.4)

func check_switch_spinning_ball_state():
	var p = randf()
	if p < 0.6:
		idle_next_state = 1
	elif p < 0.8:
		idle_next_state = 2
	else:
		idle_next_state = 5
	idle(0.8)

func check_switch_burst_state():
	var p = randf()
	if p < 0.4:
		idle_next_state = 1
	elif p < 0.7:
		idle_next_state = 2
	else:
		idle_next_state = 5
	idle(0.4)

func check_switch_snipe_state():
	idle_next_state = 1
	idle(1)

func check_switch_frenzy_state():
	idle_next_state = 5
	idle(1)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	match anim_name:
		"jump_start":
			jump_starting = false
			animp.play("jump_air")
			
			#
			if state == 1:
				dash_move()
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
