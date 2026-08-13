extends StaticBody2D

class_name Casern

@export var warrior_container: Node2D
@export var lancer_container: Node2D
@export var owner_player: Player

@onready var selection_icon: Sprite2D = $Area2D/SelectionIcon
@onready var spawn: Marker2D = $Spawn
@onready var ui_casern: CanvasLayer = $UICasern
@onready var warrior_button: Button = $UICasern/Control/PanelContainer/HBoxContainer/WarriorButton
@onready var lancer_button: Button = $UICasern/Control/PanelContainer/HBoxContainer/LancerButton

var is_selected: bool = false


func _ready() -> void:
	warrior_button.pressed.connect(_on_unit_button_pressed.bind("warrior"))
	lancer_button.pressed.connect(_on_unit_button_pressed.bind("lancer"))
func can_receive_command():
	return false

func toggle_selection(value:bool):
	is_selected = value
	selection_icon.visible = value
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
				warrior_container.add_child(new_warrior)
				new_warrior.owner_player = owner_player
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
				lancer_container.add_child(new_lancer)
				new_lancer.owner_player = owner_player
				owner_player.add_militia(1)
			else : return
			
