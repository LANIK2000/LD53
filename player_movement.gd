extends RigidBody2D

var gun = false;

var speed = 15;
var jump_amount = 750;

var grounded = false;
var area_collision_count = 0;
var direction = 1;

var air_resistence = 0.01;

var torso_idle = preload("res://textures/Trucker/Torse_Idle.png");
var torso_gun = preload("res://textures/Trucker/Torse_Gun.png")
var torso_shoot = preload("res://textures/Trucker/Torse_Shoot.png")

var nearest_box = null;
var holding_box = false;
var previous_mass = 0;

var highlight_color = Color(1.5,1.5,1.5);
var normal_color = Color(1,1,1);


func _ready():
	pass

func _physics_process(delta):
	
	# If we're standing over at least one RigidBody/StaticBody, we're grounded
	# (other than the player)
	if (area_collision_count > 1):
		if not (holding_box and area_collision_count == 2):
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
	
	# Holding box
	if (holding_box):
		if (nearest_box != null):
			nearest_box.apply_central_impulse((global_position - nearest_box.global_position) * 0.1);
			nearest_box.gravity_scale = 0;
			nearest_box.mass = 0;
			nearest_box.modulate = highlight_color;
	else:
		if (nearest_box != null):
			nearest_box.gravity_scale = 1;
			nearest_box.mass = previous_mass;
			nearest_box.modulate = normal_color;
	
	# Get the nearest box the player is touching
	if not holding_box:
		var min_distance = 9999;
		for body in get_node("PickupArea").get_overlapping_bodies():
			var distance = global_position.distance_to(body.global_position)
			if body.has_node("ThisIsABoxFuckYou") and distance < min_distance:
				min_distance = distance
				nearest_box = body;
	
	

func _input(event):
	# Jumping
	var just_pressed = event.is_pressed() and not event.is_echo()
	if Input.is_key_pressed(KEY_UP) and just_pressed and grounded and linear_velocity.y > -100:
		apply_central_impulse(Vector2.UP * jump_amount)
	
	if Input.is_key_pressed(KEY_E) and just_pressed and not gun and nearest_box != null:
		holding_box = !holding_box;

# Check how many RigidBody or StaticBody objects the ray is intersecting (to check if grounded)
func _on_area_2d_body_entered(body):
	if body is RigidBody2D or body is StaticBody2D:
		area_collision_count += 1;

func _on_area_2d_body_exited(body):
	if body is RigidBody2D or body is StaticBody2D:
		area_collision_count -= 1;

# Set box back to default
func _on_pickup_area_body_exited(body):
	if body.has_node("ThisIsABoxFuckYou"):
		body.gravity_scale = 1;
		body.mass = previous_mass;
		body.modulate = normal_color;
		if (nearest_box == body):
			nearest_box = null;
			holding_box = false;
