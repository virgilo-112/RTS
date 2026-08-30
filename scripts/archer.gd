extends Unit

# =================== functions =================== #


func update_anim():
	if velocity != Vector2.ZERO :
		animated_sprite.play("Run")
	else :
		animated_sprite.play("Idle")
