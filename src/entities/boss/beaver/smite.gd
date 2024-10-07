extends Area2D

@export var player_can_be_hit: bool = false
@export var player_been_hit: bool = false
var area_player: Area2D
func _physics_process(delta: float) -> void:
	scale *= 1.018
	if (player_been_hit):
		attack_player(area_player)
func _on_body_entered(body):
	print("I love minecraft")
	if body.is_node("PlayerSquirell"):
		if player_can_be_hit:
			body.owner.take_damage(1)
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
	player_been_hit = false
	area_player = area
		
func attack_player(area):
	var breaver = get_parent().get_parent().get_node("Beaver")
	if (player_can_be_hit && breaver.can_player_be_hit):
		print("I love minecraft")
		var player = area.owner
		breaver.player_hit_restart()
		area.owner.take_damage(1)
		
