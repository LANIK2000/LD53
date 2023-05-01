extends Node2D

var delivered_boxes = 0;
var total_boxes = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in get_children():
		if i.has_node("ThisIsABoxFuckYou"):
			total_boxes += 1;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	delivered_boxes = 0;
	for body in $BoxCounter.get_overlapping_bodies():
		if body.has_node("ThisIsABoxFuckYou"):
			delivered_boxes += 1;
	$Score.text = "Boxes delivered: " + str(delivered_boxes) + "/" + str(total_boxes)
	

func _input(event):
	# Jumping
	var just_pressed = event.is_pressed() and not event.is_echo()
	if event.as_text() == "Escape" and just_pressed:
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
