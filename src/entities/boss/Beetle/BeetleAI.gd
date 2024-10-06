extends CharacterBody2D


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
var isVulnerable = false #boolean
var curDirection = 0
var player #player thing
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
	health = 100.0
	speed = 35.0
	aoeCollider = $Rotate/aoe
	mainAttackCollider = $Rotate/main_attack
	weakCollider = $Rotate/weak
	player = Singleton.player


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	position += vel * delta * speed
	position = position.clamp(Vector2.ZERO, screenSize)
	
	
	if state == 1 && (position.x > screenSize.x-10 or position.x < 10):
		vel.x *= -1
		update_direction_facing(vel)
	elif state == 1 && (position.y > screenSize.y-10 or position.y < 10):
		vel.y *= -1
		update_direction_facing(vel)
		
	
	if something_running == 0 or state == 0:
		make_decisions()
	
	

func face_player():
	var angleTo = get_angle_to(player)
	var angle = rad_to_deg(angleTo)
	if(angle > 270):
		curDirection = 3
		$Rotate.set_rotation_degrees(315)
	elif(angle > 180):
		curDirection = 2
		$Rotate.set_rotation_degrees(225)
	elif(angle > 90):
		curDirection = 1
		$Rotate.set_rotation_degrees(135)
	else:
		curDirection = 0
		$Rotate.set_rotation_degrees(45)
	
func go_to_player():
	var angleTo = get_angle_to(player)
	var distance = position.distance_to(player.position)
	face_player()
	
	#should add anim in here
	await get_tree().create_timer(1.0).timeout
	var jumpLocation = position.move_toward(player.position,distance*0.7)
	position = jumpLocation
	face_player()
	
func fly_to_player():
	var angleTo = get_angle_to(player)
	var distance = position.distance_to(player.position)
	face_player()
	
	#should add flying anim in here
	await get_tree().create_timer(1.0).timeout
	for i in range(4):
		var jumpLocation = position.move_toward(player.position,distance*0.2)
		position = jumpLocation
		await get_tree().create_timer(0.125).timeout
	face_player()
	
func update_direction_facing(dir: Vector2):
	match dir:
		Vector2(-1,-1):
			curDirection = 0
			$Rotate.set_rotation_degrees(45)
		Vector2(1,-1):
			curDirection = 1
			$Rotate.set_rotation_degrees(135)
		Vector2(1,1):
			curDirection = 2
			$Rotate.set_rotation_degrees(225)
		Vector2(-1,1):
			curDirection = 3
			$Rotate.set_rotation_degrees(315)
			
			
func _on_weak_area_shape_entered(_area_rid: RID, _area: Area2D, _area_shape_index: int, _local_shape_index: int) -> void:
	if(isVulnerable):
		take_damage(5.0)
		
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
	isVulnerable = true
	#expose vulnerable
	await get_tree().create_timer(1.0).timeout
	isVulnerable = false
	state = 0
	something_running = 0
	
	

func aoe_attack() -> void:
	#start area of attack anim
	
	go_to_player()
	await get_tree().create_timer(0.5).timeout
	#do damage
	await get_tree().create_timer(1.0).timeout
	#expose vulnerable
	isVulnerable = true
	await get_tree().create_timer(3.0).timeout
	isVulnerable = false
	state = 0
	something_running = 0
	
func second_attack() -> void:
	
	#activate
	fly_to_player()
	await get_tree().create_timer(1.5).timeout
	#ground slam
	await get_tree().create_timer(1.0).timeout
	#vulnerable
	isVulnerable = true
	await get_tree().create_timer(3.0).timeout
	isVulnerable = false
	state = 0
	something_running = 0
	
	
func rapid_attack() -> void:
	#activate rapid hit animation and attack box
	go_to_player()
	for i in range(3):
		await get_tree().create_timer(0.1).timeout
		
	await get_tree().create_timer(1.0).timeout
	isVulnerable = true
	#expose vulnerable
	await get_tree().create_timer(3.0).timeout
	isVulnerable = false
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
	
	await get_tree().create_timer(4.0).timeout
	vel = Vector2.ZERO
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
	
	await get_tree().create_timer(4.0).timeout
	vel = Vector2.ZERO
	state = 0
	something_running = 0
	
func take_damage(damage: float) -> void:
	health -= damage
	
func make_decisions() -> void:
	match state:
		0: #find new state
			if(stage == 0 && health < 50):
				stage = 1
				state = 4
				
			var stateper = rng.randi_range(0, 3)
			if(stage == 0):
				state = 1
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
		
