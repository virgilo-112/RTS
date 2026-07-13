extends CharacterBody2D

class_name Unit

var speed = 300
var destination = Vector2()
var mouse_inside = false
var is_selected = false
var av = Vector2.ZERO

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var selection_icon: Sprite2D = $SelectionIcon


func _ready():
	navigation_agent.velocity_computed.connect(_on_velocity_computed)
	navigation_agent.avoidance_enabled = true
	navigation_agent.radius = 20
	navigation_agent.max_speed = speed
	navigation_agent.neighbor_distance = 120
	navigation_agent.time_horizon_agents = 2.0
	navigation_agent.target_desired_distance = 30
	navigation_agent.avoidance_priority = 0.5


func assign_move() :
	destination = get_global_mouse_position()
	navigation_agent.target_position = destination
	
	navigation_agent.avoidance_priority = 1.0


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


func toggle_selection(value:bool):
	is_selected = value
	selection_icon.visible = value


func update_facing(_dir: float):
	pass

func update_anim():
	pass
	
