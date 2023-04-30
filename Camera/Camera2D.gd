extends Camera2D

func _ready():
	pass

func _process(delta):
	if (get_parent().ammo > 0):
		get_node("Ammo").text = "Ammo: " + str(get_parent().ammo);
	else:
		get_node("Ammo").text = "Out of ammo!";
