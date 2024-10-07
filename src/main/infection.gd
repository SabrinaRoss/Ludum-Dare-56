extends Node2D
var speed = 0.5
var destination
var line
var stretching = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	line = get_node("Line2D")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if destination != null:
		if stretching:
			var diff = destination - line.points[1]
			if diff.length() > 1:
				line.points[1] += diff.normalized() * speed
			else:
				stretching = false
		else:
			var diff = destination - line.points[0]
			if diff.length() > 1:
				line.points[0] += diff.normalized() * speed
			else:
				get_parent().queue_free()
