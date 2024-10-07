extends Area2D

@export var player_can_be_hit: bool = false
@export var player_been_hit: bool = true
var area_player: Area2D

func _ready() -> void:
	area_player = get_parent().get_node("PlayerSquirell")
func _physics_process(delta: float) -> void:
	scale *= 1.018
	attack_player(area_player)

func _on_body_entered(body):
	print("I love minecraft")
	if body.is_node("PlayerSquirrel"):
		if player_can_be_hit:
			body.owner.take_damage(1)
			player_can_be_hit = false # Disable further hits after the first
			print("Hawk Tuh")

func _on_timer_timeout():
	$AnimationPlayer.play("inirt")
	player_can_be_hit = true

func anim_end():
	queue_free()

func _on_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	player_been_hit = true
	area_player = area

func _on_area_shape_exited(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	player_been_hit	 = false

func attack_player(area):
	var breaver = get_parent().get_parent().get_node("Beaver")
	if player_been_hit && player_can_be_hit && breaver.can_player_be_hit:
		if area is Area2D:
			var player = area.owner
			breaver.player_hit_restart()
			area.owner.take_damage(360)
			player_can_be_hit = false 
