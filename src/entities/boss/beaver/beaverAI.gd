extends Node

@onready var smite = preload("res://src/entities/boss/beaver/Smite.tscn")
@export var num_of_smites: int = 50


var player_near
var cur_body
var direction = Vector2(0, 0)
var check_dir_border = 1
var count = false
func _ready() -> void:
	player_near = $Player_near
# ace attack is gonna be the reality shift which is pretty hypers, and is gonna allow for manipulating the character and use some 
# fun shaders 

# main attack is gonna be the  smite where shoot down at player location 

# ace attack is where the player get tooo place and than they get chainsawed

func _physics_process(delta: float) -> void:
	$Player_near/Player_near_sprite.rotation_degrees += .5
	if !count : 
		main_attack()
		$"..".ace_attack()
	count = true
func main_attack():
	await smite_random_position(num_of_smites)
	return true
	
func smite_player():
	var instance = smite.instantiate()
	instance.global_position = get_tree().get_root().in_group("Player").position
	instance.scale *= 1.5
	var timer = Timer.new()
	timer.wait_time = 1
	timer.one_shot = true
	timer.connect("timeout", _on_timeout)
	await timer.timeout
	add_child(timer)
	timer.start()
	get_tree().get_root().add_child(instance)

func smite_random_position(count_number_smites: int):
	for i in count_number_smites:
		var timer = Timer.new()
		timer.wait_time = .1
		timer.one_shot = true
		timer.connect("timeout", _on_timeout)
		add_child(timer)
		timer.start()
		await timer.timeout
		var instance = smite.instantiate()
		instance.scale *= 1.5
		var viewport = get_tree().get_root().get_viewport().get_visible_rect()
		instance.global_position = Vector2(randf_range(10, viewport.size.x -10), randf_range(10, viewport.size.y - 10))
		instance.rotation_degrees = randi_range(0, 360)
		get_tree().get_root().add_child(instance)
	
	var timer = Timer.new()
	timer.wait_time = 2
	timer.one_shot = true
	timer.connect("timeout", _on_timeout)
	add_child(timer)
	timer.start()
	await timer.timeout
	count = false
func second_attack(): # proximity attack
	#play the animation
	# TODO: Do shit with the player when the player is more developed
	var player = cur_body.owner
	player.take_damage(999999999)
	pass

	
func _on_timeout(): #timeout for the smite
	pass
	
func _on_body_entered(body) -> void:
	$Timer_Player_Near.start()
	cur_body = body

func _on_body_exited(_body) -> void:
	$Timer_Player_Near.stop()

func _on_timer_player_near_timeout(_body) -> void:
	second_attack()
