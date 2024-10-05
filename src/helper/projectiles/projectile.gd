extends CharacterBody2D
class_name Projectile

@export var damage : float
var speed : float
var dir : Vector2

func _ready() -> void:
	await get_tree().create_timer(30).timeout
	explode()

func _process(delta: float) -> void:
	global_rotation = dir.angle()

func _physics_process(delta: float) -> void:
	velocity = dir * speed
	move_and_slide()
	if get_last_slide_collision():
		explode()

func deal_damage(target_area : Area2D):
	var target = target_area.owner
	target.take_damage(damage)
	explode()

func explode():
	queue_free()
