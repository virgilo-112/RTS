extends CharacterBody2D

class_name Unit

var speed = 300
var destination = Vector2()
var mouse_inside = false
var is_selected = false
var av = Vector2.ZERO

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var selection_icon: Sprite2D = $SelectionIcon

var current_command: Command


func _ready():
	navigation_agent.velocity_computed.connect(_on_velocity_computed)
	navigation_agent.navigation_finished.connect(_on_navigation_finished)
	navigation_agent.avoidance_enabled = true
	navigation_agent.radius = 20
	navigation_agent.max_speed = speed
	navigation_agent.neighbor_distance = 120
	navigation_agent.time_horizon_agents = 2.0
	navigation_agent.target_desired_distance = 30
	navigation_agent.avoidance_priority = 0.5

func set_destination(pos: Vector2):
	destination = pos
	navigation_agent.target_position = pos
	navigation_agent.avoidance_priority = 1.0


func assign_command(command) :
	current_command = command
	command.start(self)

func _on_navigation_finished() -> void:
	current_command.on_arrived(self)


func move():
	if navigation_agent.is_navigation_finished() :
		velocity = Vector2.ZERO
		return
		
	var dir = global_position.direction_to(navigation_agent.get_next_path_position())
	navigation_agent.set_velocity(dir * speed)

func _on_velocity_computed(safe_velocity):
	velocity = safe_velocity
	move_and_slide()

	update_anim()
	update_facing(velocity.x)


func can_receive_command():
	return true


func toggle_selection(value:bool):
	is_selected = value
	selection_icon.visible = value


func update_facing(_dir: float):
	pass

func update_anim():
	pass
