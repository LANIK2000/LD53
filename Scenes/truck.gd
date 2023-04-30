extends Node2D

var things = 0;

var acceleration = 1300;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	# Count overlapping rigidbodies
	things = 0;
	for body in get_node("TruckBody/GasPedal").get_overlapping_bodies():
		things += 1;
			
	if (things > 0):
		get_node("Wheel1").apply_torque_impulse(acceleration * delta * 100);
		get_node("Wheel2").apply_torque_impulse(acceleration * delta * 100);
		get_node("Wheel3").apply_torque_impulse(acceleration * delta * 100);
	
