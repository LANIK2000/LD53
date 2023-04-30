extends Node2D

@export var audio_player: AudioStreamPlayer2D
@export var truck_body: RigidBody2D

var things = 0;

var acceleration = 1300;
var gass_timer = 0;

func _ready():
	audio_player.pitch_scale = .5
	audio_player.volume_db = -10

func _process(delta):
	pass

func _physics_process(delta):
	
	if gass_timer > 0:
		gass_timer -= delta
	audio_player.volume_db = gass_timer - 10
	audio_player.pitch_scale = clamp(
		.5 + truck_body.linear_velocity.x/500 * clamp(gass_timer, 0, 1)
		, .5, 2)
	
	# Count overlapping rigidbodies
	things = 0;
	for body in get_node("TruckBody/GasPedal").get_overlapping_bodies():
		things += 1;
	
	if (things > 0):
		gass_timer = 1
		get_node("Wheel1").apply_torque_impulse(acceleration * delta * 100);
		get_node("Wheel2").apply_torque_impulse(acceleration * delta * 100);
		get_node("Wheel3").apply_torque_impulse(acceleration * delta * 100);
	
