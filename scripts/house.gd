extends StaticBody2D

class_name House

@onready var selection_icon: Sprite2D = $Area2D/SelectionIcon
@onready var spawn: Marker2D = $Spawn
@onready var ui_house: CanvasLayer = $UIHouse



@export var owner_player: Player
@export var pawn_container: Node2D

var is_selected: bool = false


func can_receive_command():
	return false

func toggle_selection(value:bool):
	is_selected = value
	selection_icon.visible = value
	ui_house.visible = value

func _on_pawn_button_pressed() -> void:
	if owner_player.is_unit_affordable("pawn"):
		var production_timer = Timer.new()
		production_timer.wait_time = 5
		production_timer.one_shot = true
		self.add_child(production_timer)
		production_timer.start()
		owner_player.pay_unit("pawn")
		
		await production_timer.timeout
		production_timer.queue_free()
		var new_pawn = preload("res://scenes/pawn.tscn").instantiate()
		new_pawn.global_position = spawn.global_position
		pawn_container.add_child(new_pawn)
		new_pawn.owner_player = owner_player
		owner_player.add_pawn(1)
	else : 
		return
