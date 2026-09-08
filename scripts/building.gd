extends StaticBody2D

class_name Building


# =================== parameters =================== #

# --------- Building data --------- #
@export var hp : int = 1000

# --------- Player --------- #
@export var player_id: int

# --------- Build --------- #
var builders : Array[Pawn] = []
@export var builder_count : int = 0
@export var under_construction : bool = false
@export var build_time := 15.0
@export var construction_progress_bar: ProgressBar
var build_timer := 0.0

# --------- Visual --------- #
var building_sprite : Sprite2D

# --------- Select - UI --------- #
@export var ui_building: CanvasLayer
@export var data_container: VBoxContainer
@export var button_container: HBoxContainer
@export var selection_icon: Sprite2D
var is_selected: bool = false
@export var hp_label: Label


# --------- Produce unit --------- #
@export var spawn: Marker2D


@export var interaction_points: Node2D
signal destroyed

# =================== functions =================== #


func _ready() -> void:
	build_timer = build_time
	construction_progress_bar.min_value = 0
	construction_progress_bar.max_value = build_time
	construction_progress_bar.value = 0
	construction_progress_bar.show_percentage = false
	set_color()
	set_construction_status(under_construction)
	

func _process(delta: float) -> void:
	if not under_construction:
		return

	if builder_count == 0:
		return

	build_timer -= delta * builder_count

	if build_timer <= 0.0:
		build_timer = 0.0
		finish_construction()
		return

	construction_progress_bar.value = abs(build_timer - build_time)


func can_receive_command():
	return false

func get_owner_player() -> Player:
	return GameManager.get_player(player_id)


# --------- Construction state --------- #

func set_construction_status(working : bool):
	under_construction = working
	construction_progress_bar.visible = under_construction


# --------- Build --------- #

func add_builder(pawn: Pawn) -> void:
	if pawn in builders:
		return
	builders.append(pawn)
	builder_count = builders.size()


func remove_builder(pawn: Pawn) -> void:
	if pawn not in builders:
		return
	builders.erase(pawn)
	builder_count = builders.size()

	# reste de ta logique...
func finish_construction() -> void:
	under_construction = false
	if is_instance_valid(construction_progress_bar):
		construction_progress_bar.queue_free()
	for pawn in builders:
		pawn.stop_building()
	builders.clear()


# --------- production request to server --------- #

@rpc("any_peer", "call_local")
func request_unit_production(unit_type: String) -> void:
	if !multiplayer.is_server():
		return
	# Vérifications côté serveur
	if !get_owner_player().is_unit_affordable(unit_type):
		return
	get_owner_player().pay_unit(unit_type)
	await get_tree().create_timer(5.0).timeout
	GameManager.spawn_unit(unit_type, spawn.global_position, get_owner_player())

# --------- Selection - UI --------- #

func toggle_selection(value:bool, can_interact: bool):
	is_selected = value
	selection_icon.visible = value
	if !under_construction :
		ui_building.visible = value
	button_container.visible = can_interact


func take_damage(dmg: int):
	var dmg_taken = min(dmg, hp)
	hp -= dmg_taken
	hp_label.text = ": "+var_to_str(hp)
	if hp == 0 :
		destroyed.emit()
		queue_free()
	return dmg_taken



func get_closest_point(unit_pos):
	var best = null
	var best_distance = INF
	for point in interaction_points.get_children():
		var d = point.global_position.distance_to(unit_pos)
		if d < best_distance :
			best_distance = d
			best = point
	return best.global_position



# --------- Visuals --------- #

func set_color() -> void:
	var player := GameManager.get_player(player_id)

	if player == null:
		return

	match player.color:
		"blue":
			building_sprite = $BlueSprite2D
		"red":
			building_sprite = $RedSprite2D
		"yellow":
			building_sprite = $YellowSprite2D
		"black":
			building_sprite = $BlackSprite2D
		"purple":
			building_sprite = $PurpleSprite2D

	$BlueSprite2D.visible = false
	$RedSprite2D.visible = false
	$YellowSprite2D.visible = false
	$BlackSprite2D.visible = false
	$PurpleSprite2D.visible = false

	building_sprite.visible = true


func get_color_sprite() -> Sprite2D:
	var player := GameManager.get_player(player_id)

	match player.color:
		"blue":
			return $BlueSprite2D
		"red":
			return $RedSprite2D
		"yellow":
			return $YellowSprite2D
		"black":
			return $BlackSprite2D
		"purple":
			return $PurpleSprite2D

	return null
