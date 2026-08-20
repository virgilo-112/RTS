extends Building

class_name Casern

@export var warrior_container: Node2D
@export var lancer_container: Node2D


@onready var selection_icon: Sprite2D = $Area2D/SelectionIcon
@onready var spawn: Marker2D = $Spawn
@onready var ui_casern: CanvasLayer = $UICasern
@onready var warrior_button: Button = $UICasern/Control/PanelContainer/HBoxContainer/WarriorButton
@onready var lancer_button: Button = $UICasern/Control/PanelContainer/HBoxContainer/LancerButton
@onready var construction_progress_bar: ProgressBar = $ConstructionProgressBar


var is_selected: bool = false
@export var build_time := 15.0

var build_timer := 0.0
var construction_tween: Tween


func _ready() -> void:
	warrior_button.pressed.connect(_on_unit_button_pressed.bind("warrior"))
	lancer_button.pressed.connect(_on_unit_button_pressed.bind("lancer"))
	
	build_timer = build_time
	construction_progress_bar.min_value = 0
	construction_progress_bar.max_value = build_time
	construction_progress_bar.value = 0
	construction_progress_bar.show_percentage = false
	construction_progress_bar.visible = under_construction
	set_color().visible = true


func can_receive_command():
	return false

func toggle_selection(value:bool):
	is_selected = value
	selection_icon.visible = value
	if !under_construction:
		ui_casern.visible = value

func _on_unit_button_pressed(unit):
	match unit:
		"warrior":
			if owner_player.is_unit_affordable("warrior"):
				var production_timer = Timer.new()
				production_timer.wait_time = 5
				production_timer.one_shot = true
				self.add_child(production_timer)
				production_timer.start()
				owner_player.pay_unit("warrior")
				
				await production_timer.timeout
				production_timer.queue_free()
				
				var new_warrior = preload("res://scenes/warrior.tscn").instantiate()
				new_warrior.global_position = spawn.global_position
				new_warrior.owner_player = owner_player
				warrior_container.add_child(new_warrior)
				owner_player.add_militia(1)
			else : return
		"lancer":
			if owner_player.is_unit_affordable("lancer"):
				var production_timer = Timer.new()
				production_timer.wait_time = 5
				production_timer.one_shot = true
				self.add_child(production_timer)
				production_timer.start()
				owner_player.pay_unit("lancer")
				
				await production_timer.timeout
				production_timer.queue_free()
				
				var new_lancer = preload("res://scenes/lancer.tscn").instantiate()
				new_lancer.global_position = spawn.global_position
				new_lancer.owner_player = owner_player
				lancer_container.add_child(new_lancer)
				owner_player.add_militia(1)
			else : return


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

func start_construction_animation() -> void:
	if construction_tween:
		construction_tween.kill()
	construction_tween = create_tween()
	construction_tween.set_loops()
	construction_tween.tween_property(sprite_2d,"scale",Vector2(1.02, 0.98),0.35).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	construction_tween.tween_property(sprite_2d,"scale",Vector2(0.98, 1.02),0.35).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


func stop_construction_animation() -> void:
	if construction_tween:
		construction_tween.kill()
	var tween = create_tween()
	tween.tween_property(sprite_2d,"scale",Vector2(1.08, 1.08),0.12).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(sprite_2d,"scale",Vector2.ONE,0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
