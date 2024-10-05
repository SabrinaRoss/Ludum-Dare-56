extends Node

@onready var smite = preload("res://src/entities/Smite.tscn")

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
	add_child(timer)
	timer.start()
	add_child(instance)

func _on_timeout():
	pass
