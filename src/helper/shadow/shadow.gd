@tool
extends ColorRect

func _on_item_rect_changed() -> void:
	material.set_shader_parameter("rect", size)
