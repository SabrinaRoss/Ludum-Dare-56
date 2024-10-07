extends Area2D

@export var player_can_be_hit: bool = false

func _physics_process(delta: float) -> void:
	scale *= 1.018

func _on_body_entered(body):
	if body.is_node("PlayerSquirell"):
		if player_can_be_hit:
			body.owner.take_damage(100)

func _on_timer_timeout():
	$AnimationPlayer.play("inirt")
	player_can_be_hit = true
func anim_end():
	queue_free()
func take_damage(damage):
	pass
