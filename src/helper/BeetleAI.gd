extends RigidBody2D


var state = 0 #int
var screenSize #Vector2
var velocity #Vector2
var rng = RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screenSize = get_viewport_rect().size
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screenSize)
	
	
	if state == 1 && ((position.x > screenSize.x or position.y > screenSize.y) or (position.x < 0 or position.y < 0)):
		velocity.x *= -1
		velocity.y *= -1
	
	
	

func main_attack() -> void: 
	
	#activate hit animation and attack box
	await get_tree().create_timer(2.0).timeout
	#expose vulnerable
	await get_tree().create_timer(1.0).timeout
	state = 0
	
func aoe_attack() -> void:
	#start area of attack anim
	await get_tree().create_timer(1.0).timeout
	#do damage
	await get_tree().create_timer(1.0).timeout
	#expose vulnerable
	await get_tree().create_timer(3.0).timeout
	
func second_attack() -> void:
	pass
	
func rapid_attack() -> void:
	pass
	
func move() -> void:
	
	var direction = rng.randi_range(0,4)
	match direction:
		0:
			velocity = Vector2(1,1)
		1:
			velocity = Vector2(-1,1)
		2:
			velocity = Vector2(1,-1)
		3:
			velocity = Vector2(-1,-1)
	
	await get_tree().create_timer(4.0).timeout
	velocity = Vector2.ZERO
	state = 0
	
	
func take_damage() -> void:
	pass
	
func make_decisions() -> void:
	match state:
		0: #find new state
			
			pass
		1:	#default walking
			move()
		2:	#basic attack
			main_attack()
		3:	#flutter wings aoe
			pass
		4:  #jump and land aoe
			pass
		5:  #rapid attack
			pass
		
	
	pass
