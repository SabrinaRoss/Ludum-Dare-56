extends Projectile
class_name Acorn

func explode():
	queue_free()

func reflect():
	$Hurtbox.set_collision_layer_value(4, false)
	$Hurtbox.set_collision_layer_value(2, true)
