extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	if $/root/DatabaseWannabe.get_data("crawled_speed") != 600:
		queue_free()

