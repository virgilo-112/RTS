extends Unit

@export var vertical_position : int



# =================== functions =================== #
func _ready() -> void:
	super()
	animated_sprite.frame_changed.connect(_on_attack_frame_changed)

func start_attack(enemy : Node2D):
	if enemy is Unit :
		if enemy.position.y > position.y + 40 :
			vertical_position = 1
		elif enemy.position.y < position.y - 40 :
			vertical_position = -1
		else :
			vertical_position = 0

	elif enemy is Building :
		if enemy.position.y > position.y + 80 :
			vertical_position = 1
		elif enemy.position.y < position.y - 80 :
			vertical_position = -1
		else :
			vertical_position = 0
			
	action = Action.ATTACKING
	if !enemy.destroyed.is_connected(stop_attacking):
		enemy.destroyed.connect(stop_attacking)


func _on_attack_frame_changed() -> void:
	if action != Action.ATTACKING:
		return

	if current_command == null:
		return

	if !["Attack", "Attack_Up", "Attack_Down"].has(animated_sprite.animation):
		return

	if animated_sprite.frame == 1:
		current_command.deal_damage()


func stop_attacking():
	action = Action.IDLE
	update_anim()


func reset_action():
	match action :
		Action.KNIFING:
			stop_attacking()


func update_anim():
	if animated_sprite == null:
		return

	var animation_name: String

	match action:
		Action.MOVING:
			animation_name = "Run"
		Action.ATTACKING:
			match vertical_position:
				-1 :
					animation_name = "Attack_Up"
				1 :
					animation_name = "Attack_Down"
				0 :
					animation_name = "Attack"
		_:
			animation_name = "Idle"

	if animated_sprite.animation != animation_name:
		animated_sprite.play(animation_name)
