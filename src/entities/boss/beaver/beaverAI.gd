extends Node

@onready var smite = preload("res://src/entities/Smite.tscn")

var player_near
var cur_body

func _ready() -> void:
	player_near = $Player_near
	
# ace attack is gonna be the reality shift which is pretty hypers, and is gonna allow for manipulating the character and use some 
# fun shaders 

# main attack is gonna be the  smite where shoot down at player location 

# ace attack is where the player get tooo place and than they get chainsawed

func main_attack():
	var instance = smite.instance()
	self.global_position = get_tree().root.in_group("Player").position
	var timer = Timer.new()
	timer.wait_time = 0.5
	timer.one_shot = true
	timer.connect("timeout", _on_timeout)
	await timer.time_left <= 0
	add_child(timer)
	timer.start()
	add_child(instance)

<<<<<<< HEAD
=======
func smite_random_position(count_number_smites: int):
	for i in count_number_smites:
		var timer = Timer.new()
		timer.wait_time = .15
		timer.one_shot = true
		timer.connect("timeout", _on_timeout)
		add_child(timer)
		timer.start()
		await timer.timeout
		var instance = smite.instantiate()
		var viewport = get_viewport().get_visible_rect()
		instance.global_position = Vector2(randf_range(0, viewport.size.x), randf_range(0, viewport.size.y))
		instance.rotation_degrees = randi_range(0, 360)
		add_child(instance)
	
	var timer = Timer.new()
	timer.wait_time = 2
	timer.one_shot = true
	timer.connect("timeout", _on_timeout)
	add_child(timer)
	timer.start()
	await timer.timeout
	count = false
>>>>>>> fcb77a7d650997bbaaf971c45eb452d0ddf4303c
func second_attack(): # proximity attack
	if cur_body.is_in_group("Player"):
		#play the animation
		# TODO: Do shit with the player when the player is more developed
		pass
	pass
	
func _on_timeout(): #timeout for the smite
	pass
	

func _on_body_entered(body) -> void:
	$Timer_Player_Near.start()
	cur_body = body

<<<<<<< HEAD

func _on_body_exited(body) -> void:
=======
func _on_body_exited(_body) -> void:
>>>>>>> fcb77a7d650997bbaaf971c45eb452d0ddf4303c
	$Timer_Player_Near.stop()

func _on_timer_player_near_timeout(body) -> void:
	second_attack()
