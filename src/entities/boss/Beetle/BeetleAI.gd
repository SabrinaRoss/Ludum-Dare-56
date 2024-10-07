extends CharacterBody2D


var aoe_damage = 1
var main_attack_damage = 1

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
	screenSize = get_viewport_rect().size
	health = 1.0
	speed = 45.0
	aoeCollider = $Rotate/aoe
	mainAttackCollider = $Rotate/main_attack
	weakCollider = $Rotate/weak
	aPlayer = $AnimationPlayer
	
	player = get_parent().get_node("PlayerAnt")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	state = 2
	
	position += vel * delta * speed
	position = position.clamp(Vector2.ZERO, screenSize)
	
	
	if (state == 1 || state == 6) && (position.x > screenSize.x-10 or position.x < 10):
		vel.x *= -1
		update_direction_facing(vel)
		update_direction_walking()
	elif (state == 1 || state == 6) && (position.y > screenSize.y-10 or position.y < 10):
		vel.y *= -1
		update_direction_facing(vel)
		update_direction_walking()
		
	
	if something_running == 0 or state == 0:
		make_decisions()
	
	

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
	if(angle.y > 0):
		angle.y = 1
	else:
		angle.y = -1
	update_direction_facing(angle)
	
func go_to_player():
	var playerPos = player.global_position
	var angleTo = get_angle_to(playerPos - global_position)
	var distance = global_position.distance_to(playerPos)
	face_player()
	
	#should add anim in here
	pick_between_four(["Telegraph_attack_up_left","Telegraph_attack_up","Telegraph_attack_down","Telegraph_attack_down_left"])
	await get_tree().create_timer(1.0).timeout
	var distanceToJump =distance-screenSize.x/8
	update_direction_walking()
	for i in range(100):
		var jumpLocation = position.move_toward(playerPos,distanceToJump*0.01)
		position = jumpLocation
		await get_tree().create_timer(0.01).timeout
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

func main_attack() -> void: 
	#activate hit animation and attack box
	go_to_player()
	await get_tree().create_timer(2.0).timeout
	pick_between_four(["Attack_up_left","Attack_up","Attack_down","Attack_down_left"])
	await $AnimationPlayer.animation_finished
	pick_between_two(["RESET_left","RESET"])
	pick_between_two(["Weak_left","Weak"])
	#expose vulnerable
	await $AnimationPlayer.animation_finished
	
	pick_between_two(["RESET_left","RESET"])
	state = 0
	something_running = 0
	
	

func aoe_attack() -> void:
	#start area of attack anim
	
	go_to_player()
	await get_tree().create_timer(2.0).timeout
	pick_between_two(["Telegraph_fly_left","Telegraph_fly"])
	await get_tree().create_timer(0.75).timeout
	pick_between_two(["Fly_left","Fly"])
	await get_tree().create_timer(1.5).timeout
	pick_between_two(["RESET_left","RESET"])
	pick_between_two(["Weak_left","Weak"])
	await get_tree().create_timer(2.5).timeout
	
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
	go_to_player()
	await get_tree().create_timer(2.0).timeout
	pick_between_four(["Attack_rapid_up_left","Attack_rapid_up","Attack_rapid_down","Attack_rapid_down_left"])
	await get_tree().create_timer(1.25).timeout
	pick_between_two(["RESET_left","RESET"])
	pick_between_two(["Weak_left","Weak"])
	await get_tree().create_timer(2.5).timeout
	pick_between_two(["RESET_left","RESET"])
	state = 0
	something_running = 0
	
func move() -> void:
	
	var direction = rng.randi_range(0,4)
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
	
	await get_tree().create_timer(4.0).timeout
	vel = Vector2.ZERO
	pick_between_two(["RESET_left","RESET"])
	state = 0
	something_running = 0
	
func move_fast() -> void:
	var direction = rng.randi_range(0,4)
	match direction:
		0:
			vel = Vector2(1.5,1.5)
		1:
			vel = Vector2(-1.5,1.5)
		2:
			vel = Vector2(1.5,-1.5)
		3:
			vel = Vector2(-1.5,-1.5)
	update_direction_facing(vel/1.5)
	update_direction_walking()
	
	await get_tree().create_timer(4.0).timeout
	vel = Vector2.ZERO
	pick_between_two(["RESET_left","RESET"])
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
	$DamageAnimp.play("damage")
	if health <= 0:
		death()

func death():
	Singleton.main.bossDeath()

func make_decisions() -> void:
	match state:
		0: #find new state
			pick_between_two(["RESET_left","RESET"])
			if(stage == 0 && health < 50):
				stage = 1
				state = 4
				
			var stateper = rng.randi_range(1, 3)
			if(stage == 0):
				state = stateper
			else:
				state = stateper + 3
		
		
			
		1:	#default walking
			something_running = 1
			move()
		2:	#basic attack
			something_running = 1
			main_attack()
		3:	#flutter wings aoe
			something_running = 1
			aoe_attack()
		4:  #jump and and aoe
			something_running = 1
			second_attack()
		5:  #rapid attack
			something_running = 1
			rapid_attack()
		6: #move 1.5x speed
			something_running = 1
			move_fast()
		
