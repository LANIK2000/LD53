extends CharacterBody2D

var gravity = 250;
var force = 2;
var speed = 150;
var jump_amount = 300;

var grounded = false;
var area_collision_count = 0;

func _ready():
	pass


func _process(delta):
	
	# If we're standing over at least one RigidBody/StaticBody, we're grounded
	if (area_collision_count > 0):
		grounded = true;
	else:
		grounded = false;
	
	# Gravity
	velocity.y += gravity * delta;
	
	# Inputs
	if (Input.is_key_pressed(KEY_LEFT)):
		velocity.x = -speed;
	if (Input.is_key_pressed(KEY_RIGHT)):
		velocity.x = speed;
	if (not Input.is_key_pressed(KEY_LEFT) and not Input.is_key_pressed(KEY_RIGHT)):
		# Only stop the player if grounded
		if grounded:
			velocity.x = 0;
			
	# Movement and collisions
	if move_and_slide():
		for i in get_slide_collision_count():
			var col = get_slide_collision(i)
			if col.get_collider() is RigidBody2D:
				# Apply forces to RigidBody
				col.get_collider().apply_force(col.get_normal() * -velocity.length() * force)

func _input(event):
	# Jumping
	var just_pressed = event.is_pressed() and not event.is_echo()
	if Input.is_key_pressed(KEY_UP) and just_pressed and grounded:
		velocity.y = -jump_amount;


# Check how many RigidBody or StaticBody objects the ray is intersecting (to check if grounded)
func _on_area_2d_body_entered(body):
	if body is RigidBody2D or body is StaticBody2D:
		area_collision_count += 1;

func _on_area_2d_body_exited(body):
	if body is RigidBody2D or body is StaticBody2D:
		area_collision_count -= 1;
