extends Sprite2D

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	print("!")
	queue_free()
