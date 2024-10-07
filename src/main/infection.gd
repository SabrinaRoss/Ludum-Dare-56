extends Node2D
var speed = 0.5
var destination
var line
var stretching = true

signal done_stretching

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
			emit_signal("done_stretching")
			destination = null
			
			## moving this to main script and using a signal to get when stretching is done
			
			#var diff = destination - line.points[0]
			#if diff.length() > 1:
				#line.points[0] += diff.normalized() * speed
			#else:
				#Singleton.camera.zoom += Vector2(0.1,0.1)
				#var camDiff = destination - Singleton.camera.position - Vector2(160,90)
				#Singleton.camera.position += camDiff/30.0 #ik the variable is hardcoded, stfu
				#Singleton.camera.get_node("TransitionBosses").get_node("Sprite2D").scale = Vector2(1.0,1.0)/Singleton.camera.zoom.x
				#Singleton.camera.get_node("TransitionBosses").get_node("Sprite2D").position = Singleton.camera.position + Singleton.camera.offset# - Vector2(80,45)
