extends Unit

# =================== functions =================== #
func _ready() -> void:
	super()
	animated_sprite.frame_changed.connect(_on_attack_frame_changed)

func start_attack(enemy : Node2D):
	action = Action.ATTACKING
	if !enemy.destroyed.is_connected(stop_attacking):
		enemy.destroyed.connect(stop_attacking)


func _on_attack_frame_changed() -> void:
	if action != Action.ATTACKING:
		return

	if current_command == null:
		return

	if animated_sprite.animation != "Attack":
		return

	if animated_sprite.frame == 2 or animated_sprite.frame == 6:
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
			animation_name = "Attack"
		_:
			animation_name = "Idle"

	if animated_sprite.animation != animation_name:
		animated_sprite.play(animation_name)
