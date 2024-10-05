extends RigidBody2D


var state = 0 #int
var cooldown = 0.0 #float
var screenSize #Vector2
var velocity #Vector2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screenSize = get_viewport_rect().size
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screenSize)
	pass
	
	
	

func main_attack() -> void: 
	pass
	
func aoe_attack() -> void:
	pass
	
func second_attack() -> void:
	pass
	
func move() -> void:
	
	
	await get_tree().create_timer(1.0).timeout
	
	
	pass
	
func take_damage() -> void:
	pass
	
func make_decisions() -> void:
	match state:
		0: #find new state
			
			pass
		1:	#default walking
			pass
		2:	#basic attack
			pass
		3:	#flutter wings aoe
			pass
		4:  #jump and land aoe
			pass
		5:  #rapid attack
			pass
		
	
	pass
