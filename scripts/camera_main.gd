extends Camera2D

const threshold: int = 50
var step: int = 30
@onready var viewport_size = get_viewport().size

var zoom_speed: float = 0.1
var min_zoom: float = 0.5
var max_zoom: float = 3.0

func _process(_delta: float) -> void:
	var local_mouse_pos = get_viewport().get_mouse_position()
	if local_mouse_pos.x > viewport_size.x - threshold:
		position.x += step
	elif local_mouse_pos.x < threshold:
		position.x -= step
	elif local_mouse_pos.y > viewport_size.y - threshold:
		position.y += step
	elif local_mouse_pos.y < threshold:
		position.y -= step


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom += Vector2(zoom_speed, zoom_speed)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom -= Vector2(zoom_speed, zoom_speed)
		
		zoom = zoom.clamp(Vector2(min_zoom, min_zoom), Vector2(max_zoom, max_zoom))

func move_camera_to_world_position(pos: Vector2):
	global_position = pos
	
