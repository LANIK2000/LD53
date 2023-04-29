extends RigidBody2D

var gun = true;

var speed = 15;
var jump_amount = 750;

var grounded = false;
var area_collision_count = 0;
var direction = 1;

var air_resistence = 0.01;

var torso_idle = preload("res://textures/Trucker/Torse_Idle.png");
var torso_gun = preload("res://textures/Trucker/Torse_Gun.png")
var torso_shoot = preload("res://textures/Trucker/Torse_Shoot.png")


func _ready():
	pass

func _physics_process(delta):
	
	# If we're standing over at least one RigidBody/StaticBody, we're grounded
	# (other than the player)
	if (area_collision_count > 1):
		grounded = true;
	else:
		grounded = false;
	
	# Walking
	if (Input.is_key_pressed(KEY_LEFT)):
		apply_central_impulse(Vector2.LEFT * speed * delta * 100)
		direction = -1;
		get_node("Legs").play("walking")
		get_node("Legs").speed_scale = linear_velocity.x / 200;
		
	if (Input.is_key_pressed(KEY_RIGHT)):
		apply_central_impulse(Vector2.RIGHT * speed * delta * 100)
		direction = 1;
		get_node("Legs").play("walking")
		get_node("Legs").speed_scale = linear_velocity.x / 200;
	
	# Stop walking animation
	if (not Input.is_key_pressed(KEY_LEFT) and not Input.is_key_pressed(KEY_RIGHT)):
		get_node("Legs").stop();
	
	# Sprite direction change
	get_node("Torso").scale.x = direction * abs(get_node("Torso").scale.x)
	get_node("Legs").scale.x = direction * abs(get_node("Legs").scale.x)
	
	# Air resistence
	apply_central_impulse(linear_velocity * -1 * air_resistence * delta * 100)
	
	# Gun
	if gun:
		get_node("Torso").set_texture(torso_gun);
	else:
		get_node("Torso").set_texture(torso_idle);
	
	

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
