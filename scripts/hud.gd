extends CanvasLayer

@export var owner_player : Player

@onready var wood_label: Label = $Control/ResourcePanelContainer/VBoxContainer/HBoxContainer/WoodLabel
@onready var food_label: Label = $Control/ResourcePanelContainer/VBoxContainer/HBoxContainer2/FoodLabel
@onready var coin_label: Label = $Control/ResourcePanelContainer/VBoxContainer/HBoxContainer3/CoinLabel
@onready var militia_count_label: Label = $Control/PanelContainer4/HBoxContainer/VBoxContainer/MilitiaCountLabel
@onready var pawn_count_label: Label = $Control/PanelContainer4/HBoxContainer/VBoxContainer2/PawnCountLabel
@onready var panel_container_unit_queue: PanelContainer = $PanelContainerUnitQueue
@onready var h_box_unit_queue: HBoxContainer = $PanelContainerUnitQueue/HBoxUnitQueue



func _ready() -> void:
	owner_player.gold_changed.connect(_on_gold_changed)
	owner_player.wood_changed.connect(_on_wood_changed)
	owner_player.food_changed.connect(_on_food_changed)
	owner_player.pawn_count_changed.connect(_on_pawn_count_changed)
	owner_player.militia_count_changed.connect(_on_militia_count_changed)
	owner_player.unit_queued.connect(_on_unit_production_queued)
	
	panel_container_unit_queue.visible = false
	
	
func _on_gold_changed(amount):
	coin_label.text = str(amount)

func _on_wood_changed(amount):
	wood_label.text = str(amount)

func _on_food_changed(amount):
	food_label.text = str(amount)

func _on_pawn_count_changed(amount):
	pawn_count_label.text = str(amount)

func _on_militia_count_changed(amount):
	militia_count_label.text = str(amount)

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_unit_production_queued(unit_type: String, duration: int) -> void:
	if panel_container_unit_queue.visible == false:
		panel_container_unit_queue.visible = true
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

	panel_container_unit_queue.visible = h_box_unit_queue.get_child_count() > 0
	
