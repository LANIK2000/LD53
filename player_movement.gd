extends RigidBody2D

@export var gun_sound_effect: AudioStreamPlayer2D

var gun = true;

var speed = 15;
var jump_amount = 750;
var pull_force = 5;
var recoil = 200;

var grounded = false;
var area_collision_count = 0;
var direction = 1;

var air_resistence = 0.01;

var torso_idle = preload("res://textures/Trucker/Torse_Idle.png");
var torso_gun = preload("res://textures/Trucker/Torse_Gun.png");
var torso_shoot = preload("res://textures/Trucker/Torse_Shoot.png");

var GUN = load("res://Scenes/gun.tscn");

var nearest_box = null;
var holding_box = false;
var previous_mass = 0;

var nearest_gun = null;
var shooting = false;

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
		if not shooting:
			get_node("Torso").frame = 1;
	else:
		get_node("Torso").frame = 0;
	
	# Holding box
	if (holding_box):
		if (nearest_box != null):
			var direction_to_player = (global_position - nearest_box.global_position);
			nearest_box.apply_central_impulse(direction_to_player * delta * pull_force);
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
			# Picking up guns has a priority
			if body.has_node("GUN!!!"):
				nearest_gun = body;
			elif body.has_node("ThisIsABoxFuckYou") and distance < min_distance:
				min_distance = distance
				nearest_box = body;
				nearest_gun = null;
	

func _input(event):
	# Jumping
#	print(event.as_text())
	var just_pressed = event.is_pressed() and not event.is_echo()
	if event.as_text() == "Up" and just_pressed and grounded and linear_velocity.y > -100:
		apply_central_impulse(Vector2.UP * jump_amount)
	
	if event.as_text() == "Space" and just_pressed:
		if (gun):
			shooting = true;
			get_node("Torso").frame = 2;
			get_node("Torso").play("shooting");
			apply_central_impulse(Vector2.RIGHT * -direction * recoil);
			gun_sound_effect.play()
	
	if event.as_text() == "E" and just_pressed:
		if (gun):
			gun = false;
			var dropped_gun = GUN.instantiate();
			get_parent().get_parent().add_child(dropped_gun);
			dropped_gun.global_position = global_position + (Vector2.RIGHT * direction * 50);
			nearest_gun = null;
		
		elif (not gun and nearest_gun != null):
			gun = true;
			nearest_gun.queue_free();
		
		elif (not gun and nearest_box != null):
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
	if body.has_node("GUN!!!"):
		if (nearest_gun == body):
			nearest_gun = null;

func _on_torso_animation_looped():
	shooting = false;
	get_node("Torso").stop();
	get_node("Torso").frame = 1;
