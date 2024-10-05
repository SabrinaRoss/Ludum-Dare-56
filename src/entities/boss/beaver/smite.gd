extends Area2D

func _on_body_entered(body):
	if body.is_in_group("Player"):
		if $Timer.time_left < 1.0:
			pass #reduce the health or sometyhing

func _on_timer_timeout():
	queue_free()
