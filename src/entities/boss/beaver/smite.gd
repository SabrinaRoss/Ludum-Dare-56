extends Area2D

@export var player_can_be_hit: bool = false
func _on_body_entered(body):
	if body.is_in_group("Player"):
		if player_can_be_hit:
			pass #reduce the health or sometyhing

func _on_timer_timeout():
	$AnimationPlayer.play("inirt")

func anim_end():
	queue_free()
