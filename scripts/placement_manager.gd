extends Node2D

# =================== parameters =================== #

var player_id : int

# --------- Build --------- #

var buildings = {
	"house": preload("res://scenes/house.tscn"),
	"casern": preload("res://scenes/casern.tscn"),
	"archery": preload("res://scenes/archery.tscn")
}
var building_scene: PackedScene
var building_type: String

# --------- Placement ghost --------- #
var ghost: Sprite2D
var ghost_offset := Vector2.ZERO
var is_placing : bool = false

# --------- Disable input_manager --------- #
@onready var input_manager = get_tree().current_scene.get_node("LocalPlayer/InputManager")


# =================== Functions =================== #


func _process(_delta):
	if not is_placing:
		return
	ghost.global_position = get_global_mouse_position() + ghost_offset

# --------- Input --------- #

func _unhandled_input(event):
	if not is_placing:
		return
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			confirm_placement.rpc_id(1)
		elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			cancel_placement()

func setup(player: Player):
	player_id = player.player_id
# --------- Generate ghost --------- #

func start_placement(type: String):
	input_manager.set_enabled(false)
	building_type = type
	building_scene = buildings[type]
	is_placing = true

	var building: Building = building_scene.instantiate()
	building.player_id = player_id
	add_child(building)

	var sprite: Sprite2D = building.get_color_sprite()

	ghost_offset = sprite.offset

	ghost = Sprite2D.new()
	ghost.texture = sprite.texture
	ghost.modulate.a = 0.5
	add_child(ghost)
	ghost.z_index = 4

	building.queue_free()

# --------- Building placement --------- #

@rpc("any_peer", "call_local")
func confirm_placement():
	if !multiplayer.is_server():
		return
	var target = get_global_mouse_position()
	is_placing = false
	ghost.queue_free()
	ghost = null
	input_manager.set_enabled(true)
	var selected_pawns := []
	
	for object in input_manager.selected_objects:
		if object is Pawn :
			selected_pawns.append(object)
	var owner_player : Player = GameManager.get_player(player_id)
	owner_player.pay_building(building_type)
	var new_building = GameManager.spawn_building(building_scene, target, owner_player, true)
	
	for pawn in selected_pawns:
		pawn.assign_command(BuildCommand.new(new_building, target))


func cancel_placement():
	is_placing = false
	ghost.queue_free()
	ghost = null
	input_manager.set_enabled(true)
