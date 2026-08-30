extends CharacterBody2D

class_name Unit


# =================== parameters =================== #

var unit_id : int

# --------- Player --------- #
@export var owner_player : Player

# --------- Actions --------- #
@export var abilities: Array[String] = []
var current_command: Command

# --------- Movement --------- #
var speed = 300
var destination = Vector2()
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

# --------- Selection --------- #
var mouse_inside = false
var is_selected = false

# --------- Animation --------- #
var animated_sprite : AnimatedSprite2D
var facing := 1 # 1 = droite, -1 = gauche

# --------- FOW --------- # *WIP*
var vision_range : int = 150


# =================== functions =================== #


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
	$SelectionIcon.visible = false
	set_color().visible = true


func _physics_process(_delta: float) -> void:
	move()


# --------- Movement --------- #

func set_destination(pos: Vector2):
	destination = pos
	navigation_agent.target_position = pos
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
	if velocity.x > 0.1:
		facing = 1
	elif velocity.x < -0.1:
		facing = -1
	update_facing(facing)


# --------- Actions --------- #

func can_receive_command():
	return true

func has_ability(ability: String) -> bool:
	return ability in abilities


func assign_command(command) :
	current_command = command
	command.start(self)


func _on_navigation_finished() -> void:
	if current_command == null:
		return
	if not is_instance_valid(current_command):
		current_command = null
		return
	current_command.on_arrived(self)


func reset_action():
	pass


# --------- Selection --------- #

func toggle_selection(value:bool):
	is_selected = value
	$SelectionIcon.visible = value


# --------- Animation --------- #

func update_facing(dir):
	animated_sprite.flip_h = dir < 0


func update_anim():
	pass


func set_color() -> AnimatedSprite2D:
	match owner_player.color :
		"blue":
			animated_sprite = $BlueAnimatedSprite2D
		"red":
			animated_sprite = $RedAnimatedSprite2D
		"yellow":
			animated_sprite = $YellowAnimatedSprite2D
		"black":
			animated_sprite = $BlackAnimatedSprite2D
		"purple":
			animated_sprite = $PurpleAnimatedSprite2D
	return animated_sprite
