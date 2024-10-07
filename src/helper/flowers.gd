extends Node2D


func _physics_process(delta: float) -> void:
	for flower in get_children():
		flower.get_node("AnimationPlayer").speed_scale = randf_range(0.5, 2)
