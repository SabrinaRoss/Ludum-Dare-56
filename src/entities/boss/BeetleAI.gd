<<<<<<< HEAD
extends Boss
=======
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
>>>>>>> 1e7770620508850f14e21550d620e0d240b5ca71


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
	
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
<<<<<<< HEAD
	pass
=======
	
	
	#activate hit animation and attack box
	mainAttackCollider.activate()
	await get_tree().create_timer(2.0).timeout
	mainAttackCollider.deactivate()
	isVulnerable = true
	#expose vulnerable
	await get_tree().create_timer(1.0).timeout
	isVulnerable = false
	state = 0
>>>>>>> 1e7770620508850f14e21550d620e0d240b5ca71
	
	

func aoe_attack() -> void:
<<<<<<< HEAD
	pass
	
func second_attack() -> void:
	pass
=======
	#start area of attack anim
	
	await get_tree().create_timer(0.5).timeout
	aoeCollider.activate()
	#do damage
	await get_tree().create_timer(1.0).timeout
	aoeCollider.deactivate()
	#expose vulnerable
	isVulnerable = true
	await get_tree().create_timer(3.0).timeout
	isVulnerable = false
	state = 0
	
func second_attack() -> void:
	#start jump anim
	#add target to player
	await get_tree().create_timer(1.0).timeout
	#ground slam
	aoeCollider.activate()
	await get_tree().create_timer(1.0).timeout
	aoeCollider.deactivate()
	#vulnerable
	isVulnerable = true
	await get_tree().create_timer(3.0).timeout
	isVulnerable = false
	state = 0
	
	
func rapid_attack() -> void:
	#activate rapid hit animation and attack box
	for i in range(3):
		mainAttackCollider.activate()
		await get_tree().create_timer(0.1).timeout
		mainAttackCollider.deactivate()
		
	await get_tree().create_timer(1.0).timeout
	isVulnerable = true
	#expose vulnerable
	await get_tree().create_timer(3.0).timeout
	isVulnerable = false
	state = 0
>>>>>>> 1e7770620508850f14e21550d620e0d240b5ca71
	
func move() -> void:
	pass
	
func take_damage() -> void:
	pass
	
func make_decisions() -> void:
	"""
	Beetle actions-
	scurry around semi-randomly
	
	"""
	
	pass
