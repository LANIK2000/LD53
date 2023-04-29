extends Sprite2D

@export var textures: Array[Texture]

var crawled_distance = 100

var camera: Camera2D
func _ready():
	
	texture = null

var timer = 0.0
var index = 0
func _process(delta):
	
	crawled_distance += delta * 10
	
	if camera == null:
		camera = get_node("/root/Camera") as Camera2D
	
	timer += delta * 4
	if timer >= 1:
		timer = 0
		index += 1
		if index == textures.size():
			index = 0
	queue_redraw()

func _draw():
	camera = get_node("/root/Camera") as Camera2D
	if camera == null:
		return
	var width = ProjectSettings.get_setting("display/window/size/viewport_width")
	var height = ProjectSettings.get_setting("display/window/size/viewport_height")
	var x = camera.position.x - width/2
	var y = camera.position.y - height/2
	var texture = textures[index as int] as Texture2D
	
	draw_rect(Rect2(0, y, crawled_distance, height), Color(.196,.196,.196))
	
	var start = y - texture.get_height()
	var end = y + height + texture.get_height()
	var step = texture.get_height()
	var i = start
	while i < end:
		draw_texture(texture, Vector2(crawled_distance, i))
		i += step
	
	













