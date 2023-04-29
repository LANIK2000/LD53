extends RigidBody2D

var speed = 20;
var jump_amount = 650;

var grounded = false;
var area_collision_count = 0;
var direction = 1;

var air_resistence = 0.01;

func _ready():
	pass


func _process(delta):
	
	# If we're standing over at least one RigidBody/StaticBody, we're grounded
	if (area_collision_count > 1):
		grounded = true;
	else:
		grounded = false;
	
	# Inputs
	if (Input.is_key_pressed(KEY_LEFT)):
		apply_central_impulse(Vector2.LEFT * speed)
		direction = -1;
	if (Input.is_key_pressed(KEY_RIGHT)):
		apply_central_impulse(Vector2.RIGHT * speed)
		direction = 1;
		
	get_node("Torso").scale.x = direction * abs(get_node("Torso").scale.x)
	get_node("Legs").scale.x = direction * abs(get_node("Legs").scale.x)
	
	apply_central_impulse(linear_velocity * -1 * air_resistence)
		
	

func _input(event):
	# Jumping
	var just_pressed = event.is_pressed() and not event.is_echo()
	if Input.is_key_pressed(KEY_UP) and just_pressed and grounded and linear_velocity.y > -100:
		apply_central_impulse(Vector2.UP * jump_amount)


# Check how many RigidBody or StaticBody objects the ray is intersecting (to check if grounded)
func _on_area_2d_body_entered(body):
	if body is RigidBody2D or body is StaticBody2D:
		area_collision_count += 1;

func _on_area_2d_body_exited(body):
	if body is RigidBody2D or body is StaticBody2D:
		area_collision_count -= 1;
