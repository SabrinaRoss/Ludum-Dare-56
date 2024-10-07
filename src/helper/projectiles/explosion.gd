extends Sprite2D

func _ready() -> void:
	$explode.pitch_scale = randf_range(0.4, 0.6)
	$explode.play()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
