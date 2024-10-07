extends Node2D
var scaleMultiplier = 5
var fade = 0.05
var opacityChange:float
var intensity
var goalScale:float
var sprite

func _ready() -> void:
	sprite = get_node("Sprite2D")

func setIntensity(i) -> void:
	intensity = i
	goalScale = float(intensity)*float(scaleMultiplier)/float(Singleton.player.max_health)
	opacityChange = float(fade)/float(goalScale)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	sprite.modulate.a -= opacityChange
	scale += Vector2(1,1) * fade
	if scale.x > goalScale:
		queue_free()
