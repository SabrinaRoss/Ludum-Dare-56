extends Projectile
class_name Acorn

func explode():
	queue_free()

func _process(delta: float) -> void:
	global_rotation = dir.angle() + 3 * PI / 2

func reflect():
	$Hurtbox.set_collision_layer_value(4, false)
	$Hurtbox.set_collision_mask_value(2, false)
	$Hurtbox.set_collision_mask_value(3, true)
