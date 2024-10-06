extends Projectile

var explosion_scene = preload("res://src/helper/projectiles/nut_explosion.tscn")

var bounces = 0
var locked = false

func _physics_process(delta: float) -> void:
	velocity = dir * speed
	var last_vel = velocity
	move_and_slide()
	var col = get_last_slide_collision()
	if col:
		locked = false
		if bounces:
			bounces -= 1
			dir = last_vel.bounce(col.get_normal()).normalized()
		else:
			explode()

func explode():
	var new_explosion = explosion_scene.instantiate()
	new_explosion.global_position = global_position
	get_parent().get_parent().get_node("Effects").call_deferred("add_child", new_explosion)
	queue_free()
