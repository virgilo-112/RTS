extends CanvasLayer


# =================== parameters =================== #

# --------- Player --------- #
var player_id : int

# --------- Menu UI --------- #
@export var cog_menu: PanelContainer

# --------- Resources Count --------- #
@export var wood_label: Label
@export var food_label: Label
@export var coin_label: Label

# --------- Unit Count --------- #
@export var pawn_count_label: Label
@export var militia_count_label: Label

# --------- Queue --------- #
@export var h_box_unit_queue: HBoxContainer
@export var unit_queue: PanelContainer


# =================== functions =================== #

func _ready() -> void:
	unit_queue.visible = false
	cog_menu.visible = false

# --------- Connect player and HUD --------- #

func setup(player: Player) -> void:
	player_id = player.player_id
	player.gold_changed.connect(_on_gold_changed)
	_on_gold_changed(player.gold)
	player.wood_changed.connect(_on_wood_changed)
	_on_wood_changed(player.wood)
	player.food_changed.connect(_on_food_changed)
	_on_food_changed(player.food)
	player.pawn_count_changed.connect(_on_pawn_count_changed)
	_on_pawn_count_changed(player.pawn_count)
	player.militia_count_changed.connect(_on_militia_count_changed)
	_on_militia_count_changed(player.militia_count)
	player.unit_queued.connect(_on_unit_production_queued)
	print("signal connected")
	

# --------- Resources count --------- #

func _on_gold_changed(amount):
	coin_label.text = str(amount)


func _on_wood_changed(amount):
	wood_label.text = str(amount)


func _on_food_changed(amount):
	food_label.text = str(amount)


# --------- Units count --------- #

func _on_pawn_count_changed(amount):
	pawn_count_label.text = str(amount)


func _on_militia_count_changed(amount):
	militia_count_label.text = str(amount)


# --------- Menu --------- #

func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_cog_icon_pressed() -> void:
	cog_menu.visible = true


func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


# --------- Queue --------- #

func _on_unit_production_queued(unit_type: String, duration: int) -> void:
	print("signal received")
	if unit_queue.visible == false:
		unit_queue.visible = true
	var queue_time := Timer.new()
	queue_time.one_shot = true
	queue_time.wait_time = duration

	var vbox := VBoxContainer.new()
	h_box_unit_queue.add_child(vbox)

	var unit_texture := TextureRect.new()
	unit_texture.custom_minimum_size = Vector2(64, 64)
	unit_texture.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL

	match unit_type:
		"pawn":
			unit_texture.texture = preload("uid://c6le8jpusgoyi")
		"warrior":
			unit_texture.texture = preload("uid://btosrp6ava74g")
		"lancer":
			unit_texture.texture = preload("uid://1k0tx44rnko0")
		"archer":
			unit_texture.texture = preload("uid://bxjk0i0ynxe3n")

	var progress_bar := ProgressBar.new()
	progress_bar.min_value = 0
	progress_bar.max_value = duration
	progress_bar.value = 0
	progress_bar.show_percentage = false

	vbox.add_child(unit_texture)
	vbox.add_child(progress_bar)

	add_child(queue_time)
	queue_time.start()

	while not queue_time.is_stopped():
		progress_bar.value = duration - queue_time.time_left
		await get_tree().process_frame

	vbox.queue_free()
	queue_time.queue_free()
	await get_tree().process_frame

	unit_queue.visible = h_box_unit_queue.get_child_count() > 0
