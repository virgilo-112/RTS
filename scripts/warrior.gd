extends Unit


# =================== functions =================== #


func start_attack(enemy : Node2D):
	action = Action.ATTACKING
	if !enemy.destroyed.is_connected(stop_attacking):
		enemy.destroyed.connect(stop_attacking)
	$AttackTimer.start()


func _on_attack_timer_timeout() -> void:
	if current_command is AttackCommand:
		current_command.on_attack_tick(self)


func stop_attacking():
	action = Action.IDLE
	$AttackTimer.stop()
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
