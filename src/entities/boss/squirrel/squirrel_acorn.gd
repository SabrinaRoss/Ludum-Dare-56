extends Projectile
class_name Acorn

var explosion_scene = preload("res://src/helper/projectiles/nut_explosion.tscn")

func explode():
	var new_explosion = explosion_scene.instantiate()
	new_explosion.global_position = global_position
	new_explosion.scale *= 2
	get_parent().get_parent().get_node("Effects").call_deferred("add_child", new_explosion)
	queue_free()

func _process(delta: float) -> void:
	global_rotation = dir.angle() + 3 * PI / 2

func reflect():
	$Hurtbox.set_collision_layer_value(4, false)
	$Hurtbox.set_collision_mask_value(2, false)
	$Hurtbox.set_collision_mask_value(3, true)
