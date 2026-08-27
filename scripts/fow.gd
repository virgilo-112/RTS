extends Sprite2D

var image : Image

@export var map_world_rect := Rect2(
	-5000,
	-3000,
	10000,
	6000
)
var player_objects : Array[Node2D]=[]

@onready var shader_material: ShaderMaterial = material as ShaderMaterial

var explored_positions: Array[Vector2] = []
var explored_radii: Array[float] = []

func _ready() -> void:
	image = make_image(1.0)
	update_texture()

func make_image(alpha: float) -> Image:
	var img = Image.create_empty(10000,6000, false, Image.FORMAT_RGBA8)
	img.fill(Color(0.0, 0.0, 0.0, alpha))
	return img


func update_texture() -> void :
	self.texture = ImageTexture.create_from_image(image)



func _process(_delta: float) -> void:
	var positions: Array[Vector2] = []
	var radii: Array[float] = []

	for object in player_objects:
		if object is Building or object is Unit:
			var position := object.global_position - map_world_rect.position


			explored_positions.append(position)
			explored_radii.append(object.vision_range)

	material.set_shader_parameter("object_positions", positions)
	material.set_shader_parameter("object_radii", radii)
	material.set_shader_parameter("object_count", positions.size())

func register_object(object : Node2D) -> void:
	if not object in player_objects :
		player_objects.append(object)
	object.tree_exited.connect( func(): 
		unregister_object(object), CONNECT_ONE_SHOT ) 
	

func unregister_object(object: Node2D) -> void: 
	player_objects.erase(object)
	
