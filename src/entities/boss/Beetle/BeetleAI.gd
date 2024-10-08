extends CharacterBody2D

var max_health = 500

var move_state_time = 4

var main_attack_state_move_speed = 75
var main_attack_range = 120
var main_attack_speed = 130
var main_attack_spacing = 60

var flutter_aoe_max_dist = 60

var rapid_attack_state_move_speed = 75

var quick_walk_mult = 2

var aoe_damage = 1
var main_attack_damage = 1

@onready var lunge_indicator_scene = preload("res://src/helper/telegraphs/beetle_lunge.tscn")

var cur_lunge_indic = null

# 0 - pick state
# 1 - move state
# 2 - main attack state
# 3 - flutter aoe state
# 4 - jump aoe state
# 5 - rapid attack state
# 6 - fast move state
var state = 0 #int
var screenSize #Vector2
var vel #Vector2
var rng = RandomNumberGenerator.new()
var health #float
var stage = 0
var something_running = 0
var speed = 0.0 #float
var aoeCollider
var mainAttackCollider
var weakCollider
var curDirection = 0
var player #player thing
var aPlayer #animation_player
"""
Direction:
0 is upper left (45deg)
1 is upper right (135deg)
2 is lower right (225deg)
3 is lower left (315deg)
"""


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	vel = Vector2.ZERO
	screenSize = Vector2(180, 180)
	health = max_health
	speed = 45.0
	aoeCollider = $Rotate/aoe
	mainAttackCollider = $Rotate/main_attack
	weakCollider = $Rotate/weak
	aPlayer = $AnimationPlayer
	
	player = get_parent().get_node("PlayerAnt")

func play_footstep():
	var pitch = randf_range(0.9, 1.1)
	$Sounds/walk.pitch_scale = pitch
	$Sounds/walk.play()

func play_flutter():
	var pitch = randf_range(0.9, 1.1)
	$Sounds/wing_flap.pitch_scale = pitch
	$Sounds/wing_flap.play()

func _process(delta: float) -> void:
	if cur_lunge_indic != null:
		var dir_vect = (player.global_position - global_position).normalized()
		cur_lunge_indic.global_rotation = dir_vect.angle()
		cur_lunge_indic.global_position = global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position += vel * delta * speed
	#position = position.clamp(Vector2.ZERO, screenSize)
	
	if $AnimationPlayer.current_animation == "high_fly_mid":
		var t = create_tween()
		t.tween_property(self, "global_position", player.global_position, 0.1)
	
	if (state == 1 || state == 4) && (position.x > screenSize.x/2. - 20 or position.x < -screenSize.x/2. + 20):
		vel.x *= -1
		update_direction_facing(vel if state == 1 else vel / quick_walk_mult)
		update_direction_walking()
	elif (state == 1 || state == 4) && (position.y > screenSize.y/2. - 20 or position.y < -screenSize.y/2. + 20):
		vel.y *= -1
		update_direction_facing(vel if state == 1 else vel / quick_walk_mult)
		update_direction_walking()
	
	position = pos_clamp(position)
	
	if something_running == 0 or state == 0:
		make_decisions()
	
	

func pos_clamp(pos):
	pos.x = clamp(pos.x, -screenSize.x/2. + 20, screenSize.x/2. - 20)
	pos.y = clamp(pos.y, -screenSize.y/2. + 20, screenSize.y/2. - 20)
	return pos

func pick_between_four(anims):
	match curDirection:
		0:
			aPlayer.play(anims[0])
		1:
			aPlayer.play(anims[1])
		2:
			aPlayer.play(anims[2])
		3:
			aPlayer.play(anims[3])

func pick_between_two(anims): #left is 1
	if(curDirection == 0 || curDirection == 3):
		aPlayer.play(anims[0])
	else:
		aPlayer.play(anims[1])

func face_player():
	var angleTo = get_angle_to(player.position)
	var angle = Vector2.from_angle(angleTo)
	
	if(angle.x > 0):
		angle.x = 1
	else:
		angle.x = -1
	if(angle.y > -0.2):
		angle.y = 1
	else:
		angle.y = -1
	update_direction_facing(angle)
	
func go_to_player(move_speed):
	var playerPos = player.global_position
	var angleTo = get_angle_to(playerPos - global_position)
	var distance = global_position.distance_to(playerPos)
	face_player()
	
	pick_between_four(["Telegraph_move_up_left","Telegraph_move_up","Telegraph_move_down","Telegraph_move_down_left"])
	await $AnimationPlayer.animation_finished
	face_player()
	playerPos = player.global_position
	angleTo = get_angle_to(playerPos - global_position)
	distance = global_position.distance_to(playerPos)
	var distanceToJump = distance - main_attack_spacing
	update_direction_walking()
	var t = create_tween()
	t.tween_property(self, "global_position", global_position + (playerPos - global_position).normalized() * distanceToJump, distanceToJump / move_speed)
	await t.finished
	face_player()

func fly_to_player():
	var angleTo = get_angle_to(player.position)
	var distance = position.distance_to(player.position)
	face_player()
	
	pick_between_two(["Telegraph_fly_left","Telegraph_fly"])
	await get_tree().create_timer(0.75).timeout
	for i in range(4):
		pick_between_two(["Fly_left","Fly"])
		var jumpLocation = position.move_toward(player.position,distance*0.2)
		position = jumpLocation
		await get_tree().create_timer(0.375).timeout
	face_player()
	
func update_direction_walking():
	match curDirection:
		0:
			aPlayer.play("Walking_up_left")
		1:
			aPlayer.play("Walking_up")
		2:
			aPlayer.play("Walking_down")
		3:
			aPlayer.play("Walking_down_left")
			
	
func update_direction_facing(dir: Vector2):
	match dir:
		Vector2(-1,-1):
			curDirection = 0
		Vector2(1,-1):
			curDirection = 1
		Vector2(1,1):
			curDirection = 2
		Vector2(-1,1):
			curDirection = 3

func music_player(music):
	#play intro
	await get_tree().create_timer(3.0).timeout #length of intro
	while(health > 50):
		#play music
		await get_tree().create_timer(3.0).timeout #change time to repeat length
	
	#play transition music
	while(health > 0):
		#play 2nd stage music
		await get_tree().create_timer(3.0).timeout

func lunge():
	var new_lunge_indic = lunge_indicator_scene.instantiate()
	var dir_vect = (player.global_position - global_position).normalized()
	new_lunge_indic.global_rotation = dir_vect.angle()
	new_lunge_indic.global_position = global_position
	get_parent().get_node("BeatleTelegraphs").call_deferred("add_child", new_lunge_indic)
	cur_lunge_indic = new_lunge_indic
	var t = create_tween()
	t.tween_property(new_lunge_indic.get_node("ColorRect"), "size", Vector2(main_attack_range, 20), 1)
	
	pick_between_four(["Telegraph_lunge_up_left","Telegraph_lunge_up","Telegraph_lunge_down","Telegraph_lunge_down_left"])
	await $AnimationPlayer.animation_finished
	
	cur_lunge_indic.get_node("AnimationPlayer").play("fade")
	cur_lunge_indic = null
	
	dir_vect = (player.global_position - global_position).normalized()
	face_player()
	pick_between_four(["Attack_up_left","Attack_up","Attack_down","Attack_down_left"])
	var target_pos = global_position + dir_vect * main_attack_range
	target_pos = pos_clamp(target_pos)
	$Sounds/bite.play()
	t = create_tween()
	t.tween_property(self, "global_position", target_pos, (target_pos - global_position).length() / main_attack_speed)
	
	await t.finished
	pick_between_two(["RESET_left","RESET"])

func main_attack() -> void: 
	#activate hit animation and attack box
	await go_to_player(main_attack_state_move_speed)
	await lunge()
	pick_between_two(["Weak_left","Weak"])
	#expose vulnerable
	await $AnimationPlayer.animation_finished
	
	pick_between_two(["RESET_left","RESET"])
	state = 0
	something_running = 0
	
	

func aoe_attack() -> void:
	#start area of attack anim
	
	pick_between_two(["Telegraph_fly_left","Telegraph_fly"])
	await $AnimationPlayer.animation_finished
	pick_between_two(["Fly_left","Fly"])
	await $AnimationPlayer.animation_finished
	pick_between_two(["RESET_left","RESET"])
	pick_between_two(["Weak_left","Weak"])
	await $AnimationPlayer.animation_finished
	
	pick_between_two(["RESET_left","RESET"])
	state = 0
	something_running = 0
	
func second_attack() -> void:
	
	#activate
	fly_to_player()
	await get_tree().create_timer(1.5).timeout
	#ground slam
	await get_tree().create_timer(1.0).timeout
	#vulnerable
	
	await get_tree().create_timer(3.0).timeout
	pick_between_two(["RESET_left","RESET"])
	state = 0
	something_running = 0
	
	
func rapid_attack() -> void:
	#activate rapid hit animation and attack box
	await go_to_player(rapid_attack_state_move_speed)
	for i in 3:
		await lunge()
	pick_between_two(["RESET_left","RESET"])
	pick_between_two(["Weak_left","Weak"])
	await $AnimationPlayer.animation_finished
	pick_between_two(["RESET_left","RESET"])
	state = 0
	something_running = 0
	
func move() -> void:
	
	var direction = rng.randi_range(0,3)
	match direction:
		0:
			vel = Vector2(1,1)
		1:
			vel = Vector2(-1,1)
		2:
			vel = Vector2(1,-1)
		3:
			vel = Vector2(-1,-1)
	update_direction_facing(vel)
	update_direction_walking()
	
	await get_tree().create_timer(move_state_time).timeout
	vel = Vector2.ZERO
	pick_between_two(["RESET_left","RESET"])
	pick_between_two(["Weak_left","Weak"])
	await $AnimationPlayer.animation_finished
	state = 0
	something_running = 0

func move_fast() -> void:
	var direction = rng.randi_range(0,3)
	match direction:
		0:
			vel = Vector2(1.,1.)
		1:
			vel = Vector2(-1.,1.)
		2:
			vel = Vector2(1.,-1.)
		3:
			vel = Vector2(-1.,-1.)
	update_direction_facing(vel)
	vel *= quick_walk_mult
	update_direction_walking()
	
	await get_tree().create_timer(4.0).timeout
	vel = Vector2.ZERO
	pick_between_two(["RESET_left","RESET"])
	pick_between_two(["Weak_left","Weak"])
	await $AnimationPlayer.animation_finished
	state = 0
	something_running = 0

func high_fly():
	Singleton.main.phase_change()
	$Sounds/phase_change.play()
	$AnimationPlayer.play("high_fly_start")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("high_fly_mid")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("high_fly_land")
	await $AnimationPlayer.animation_finished
	
	
	state = 0
	something_running = 0

func deal_main_attack(area : Area2D):
	var target = area.owner
	target.take_damage(main_attack_damage)

func deal_aoe_attack(area : Area2D):
	var target = area.owner
	target.take_damage(aoe_damage)

func take_damage(damage: float) -> void:
	health -= damage
	$Sounds/hurt.play()
	if health <= 0:
		death()
	else:
		$DamageAnimp.play("damage")

func death():
	Singleton.main.bossDeath()

func make_decisions() -> void:
	match state:
		0: #find new state
			pick_between_two(["RESET_left","RESET"])
			
			var stateper = rng.randi_range(1, 2)
			if(stage == 0):
				state = stateper
			else:
				state = stateper + 2
			
			if (player.global_position - global_position).length() < flutter_aoe_max_dist and randf() < 0.5:
				state = 5
			
			if(stage == 0 && health <= max_health / 2.):
				stage = 1
				state = 6
			
			
		1:	#default walking
			something_running = 1
			move()
		2:	#basic attack
			something_running = 1
			main_attack()
		#4:  #jump and and aoe
			#something_running = 1
			#second_attack()
		3:  #rapid attack
			something_running = 1
			rapid_attack()
		4: #move 1.5x speed
			something_running = 1
			move_fast()
		5:	#flutter wings aoe
			something_running = 1
			aoe_attack()
		
		6:	#high fly
			something_running = 1
			high_fly()
