extends Node2D

var buildings = {
	"house": preload("res://scenes/house.tscn"),
	"casern": preload("res://scenes/casern.tscn"),
	"archery": preload("res://scenes/archery.tscn")
}

var building_scene: PackedScene
var selected_pawn: Pawn
var ghost: Sprite2D
var is_placing := false
@onready var input_manager = get_tree().current_scene.get_node("InputManager")


func start_placement(building_type: String, pawn: Pawn):
	input_manager.set_enabled(false)
	building_scene = buildings[building_type]
	selected_pawn = pawn
	is_placing = true

	ghost = Sprite2D.new()

	var building = building_scene.instantiate()
	var sprite = building.get_node("Sprite2D")

	ghost.texture = sprite.texture
	ghost.modulate.a = 0.5

	add_child(ghost)

	building.queue_free()

func _process(_delta):
	if not is_placing:
		return
	ghost.global_position = get_global_mouse_position()


func _unhandled_input(event):
	if not is_placing:
		return

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			confirm_placement()
		elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			cancel_placement()
			
func confirm_placement():
	var target = get_global_mouse_position()
	is_placing = false
	ghost.queue_free()
	ghost = null
	input_manager.set_enabled(true)
	selected_pawn.owner_player.pay_building(building_scene)
	selected_pawn.assign_command(BuildCommand.new(building_scene, target))

func cancel_placement():
	is_placing = false
	ghost.queue_free()
	ghost = null
	input_manager.set_enabled(true)
