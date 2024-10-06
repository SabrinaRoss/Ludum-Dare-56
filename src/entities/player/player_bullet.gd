extends Projectile

var explosion_scene = preload("res://src/helper/projectiles/nut_explosion.tscn")

func explode():
	var new_explosion = explosion_scene.instantiate()
	new_explosion.global_position = global_position
	get_parent().get_parent().get_node("Effects").call_deferred("add_child", new_explosion)
	queue_free()
