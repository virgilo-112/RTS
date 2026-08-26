extends SubViewportContainer

@onready var camera_main: Camera2D = $"../../../CameraMain"
@export var map_world_rect := Rect2(
	-5000,
	-3000,
	10000,
	6000
)
@onready var camera_minimap: Camera2D = $SubViewport/CameraMinimap
@onready var sub_viewport: SubViewport = $SubViewport
@onready var camera_rect: Panel = $CameraRect


var is_dragging := false

@onready var input_manager = get_tree().current_scene.get_node("LocalPlayer/InputManager")

func _ready() -> void:
	sub_viewport.world_2d = get_tree().root.world_2d
	var style := StyleBoxFlat.new()

	style.bg_color = Color.TRANSPARENT

	style.border_width_left = 2
	style.border_width_top = 2
	style.border_width_right = 2
	style.border_width_bottom = 2

	style.border_color = Color.WHITE

	camera_rect.add_theme_stylebox_override("panel", style)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			is_dragging = event.pressed
			input_manager.set_enabled(not is_dragging)

			if event.pressed:
				move_camera_to_minimap(event.position)

	elif event is InputEventMouseMotion and is_dragging:
		move_camera_to_minimap(event.position)

func move_camera_to_minimap(minimap_pos: Vector2) -> void:
	var normalized_pos = minimap_pos / size
	var world_pos = map_world_rect.position + normalized_pos * map_world_rect.size
	camera_main.move_camera_to_world_position(world_pos)


func update_camera_rect() -> void:
	var screen_size := Vector2(get_tree().root.get_viewport().size)

	var visible_world_size := screen_size / camera_main.zoom
	var minimap_size := Vector2(size)

	# Taille du rectangle produit en croix
	camera_rect.size = Vector2(
		visible_world_size.x / map_world_rect.size.x * minimap_size.x,
		visible_world_size.y / map_world_rect.size.y * minimap_size.y
	)

	# Position normalisée de la caméra dans la map
	var normalized_pos := (
		camera_main.global_position - map_world_rect.position
	) / map_world_rect.size

	# Position dans la minimap
	camera_rect.position = (
		normalized_pos * minimap_size
		- camera_rect.size / 2.0
	)
	
func _process(_delta: float) -> void:
	update_camera_rect()
	
