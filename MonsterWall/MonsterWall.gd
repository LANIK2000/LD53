extends Sprite2D

@export var textures: Array[Texture]

var rand = RandomNumberGenerator.new();

var camera: Camera2D = null
var player: RigidBody2D = null

var crawled_distance = 1
var crawled_speed = 200
var crawled_distance_max = 55200
var timer = 0.0
var index = 0

var hit_timer = 0

var stopped = true
var start_timer = 1

func _ready():
	$IntroSong.play()
	texture = null

func start():
	$IntroSong.stop()
	$RideSong.play()
	stopped = false
	print("started")
	start_timer = 1

func _process(delta):
	
	if camera == null:
		camera = get_parent() as Camera2D
		player = camera.get_parent() as RigidBody2D
		camera.remove_child(self)
		camera.get_parent().get_parent().add_child(self)
		global_position = Vector2(6000, 0)
		$Wall.monitoring = true
		return
	
	if stopped:
		for body in $Wall.get_overlapping_bodies():
			if body.name == "PlayerRigidBody2D":
				global_position = Vector2(0, 0)
				start()
		return
	
	if start_timer > 0:
		start_timer -= delta
		return
	
	for body in $Wall.get_overlapping_bodies():
		if body is RigidBody2D:
#			body.apply_central_impulse(Vector2.UP * 1000 * delta);
			body.apply_torque_impulse(300000 * body.mass * delta);
	
	if hit_timer > 0:
		hit_timer -= delta
		crawled_distance -= crawled_speed * delta * 4
	else:
		crawled_distance += crawled_speed * delta
	if crawled_distance > crawled_distance_max:
		crawled_distance = crawled_distance_max
	
	if player.global_position.x - global_position.x < crawled_distance:
		get_tree().reload_current_scene()
	
	$Wall.position.x = crawled_distance
	
	timer += delta * 4
	if timer >= 1:
		timer = 0
		index += 1
		if index == textures.size():
			index = 0
	queue_redraw()

func _draw():
	if camera == null || start_timer > 0:
		return
	
	var width = ProjectSettings.get_setting("display/window/size/viewport_width")
	var height = ProjectSettings.get_setting("display/window/size/viewport_height")
	
	var x = (camera.global_position.x - width/2) - global_position.x
	var y = (camera.global_position.y - height/2) - global_position.y
	var texture = textures[index as int] as Texture2D
	var tex_size = texture.get_height()
	
	if crawled_distance < x - tex_size * 4:
		crawled_distance = x - tex_size * 4
	
	draw_rect(Rect2(0, y, crawled_distance, height), Color(.196,.196,.196))
	
	var start = y - tex_size
	var end = y + height + tex_size
	var step = tex_size * 4
	var i = start
	draw_set_transform(Vector2.ZERO, 0, Vector2(4, 4))
	
	while i < end:
		draw_texture(texture, Vector2(crawled_distance / 4, i / 4))
		i += step
	

func hit_by_shotgun():
	hit_timer = 10











