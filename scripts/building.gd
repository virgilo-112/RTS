extends StaticBody2D

class_name Building


# =================== parameters =================== #

# --------- Player --------- #
var owner_player : Player

# --------- Build --------- #
var builders : Array[Pawn] = []
var under_construction : bool = false
@export var build_time := 15.0
@export var construction_progress_bar: ProgressBar
var build_timer := 0.0

# --------- Visual --------- #
var building_sprite : Sprite2D
var construction_tween: Tween

# --------- Select --------- #
@export var selection_icon: Sprite2D 
var is_selected: bool = false

# --------- Produce unit --------- #
@export var spawn: Marker2D

# --------- FOW --------- # *WIP*
var vision_range : int = 600


# =================== functions =================== #


func _ready() -> void:
	build_timer = build_time
	construction_progress_bar.min_value = 0
	construction_progress_bar.max_value = build_time
	construction_progress_bar.value = 0
	construction_progress_bar.show_percentage = false
	construction_progress_bar.visible = under_construction
	set_color().visible = true


func _process(delta: float) -> void:
	if not under_construction:
		return
	if builders.is_empty():
		return
	build_timer -= delta * builders.size()
	construction_progress_bar.value = abs(build_timer - build_time)
	if build_timer <= 0.0:
		build_timer = 0.0
		finish_construction()
		construction_progress_bar.queue_free()
		await get_tree().process_frame


func can_receive_command():
	return false


# --------- Build --------- #

func add_builder(pawn: Pawn) -> void:
	if pawn in builders:
		return
	builders.append(pawn)
	start_construction_animation()


func remove_builder(pawn: Pawn) -> void:
	if pawn not in builders:
		return
	builders.erase(pawn)


func finish_construction() -> void:
	under_construction = false
	stop_construction_animation()
	for pawn in builders:
		pawn.stop_building()
	builders.clear()


# --------- Selection --------- #

func toggle_selection(value:bool):
	is_selected = value
	selection_icon.visible = value


# --------- Visuals --------- #

func set_color() -> Sprite2D:
	match owner_player.color :
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
	return building_sprite


func start_construction_animation() -> void:
	if construction_tween:
		construction_tween.kill()
	construction_tween = create_tween()
	construction_tween.set_loops()
	construction_tween.tween_property(building_sprite,"scale",Vector2(1.02, 0.98),0.35).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	construction_tween.tween_property(building_sprite,"scale",Vector2(0.98, 1.02),0.35).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


func stop_construction_animation() -> void:
	if construction_tween:
		construction_tween.kill()
	var tween = create_tween()
	tween.tween_property(building_sprite,"scale",Vector2(1.08, 1.08),0.12).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(building_sprite,"scale",Vector2.ONE,0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
