extends Unit


# =================== functions =================== #


func update_anim():
	if animated_sprite == null:
		return

	var animation_name: String

	match action:
		Action.MOVING:
			animation_name = "Run"
		_:
			animation_name = "Idle"

	if animated_sprite.animation != animation_name:
		animated_sprite.play(animation_name)
