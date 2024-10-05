extends Projectile

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
	queue_free()
