extends CharacterBody2D

class_name Unit

var speed = 300
var click_position = Vector2()
var target_position = Vector2()
var mouse_inside = false
var is_selected = false

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var selection_icon: Sprite2D = $SelectionIcon


func assign_move() -> Vector2:
	click_position = get_global_mouse_position()
	return click_position


func move(click_pos):

	if position.distance_to(click_pos) > 3:
		
		navigation_agent.target_position = click_pos
		var nav_point_direction = to_local(navigation_agent.get_next_path_position()).normalized()
		velocity = nav_point_direction * speed 
		update_anim(velocity)
		move_and_slide()
		update_facing(velocity.x)
	else:
		velocity = Vector2.ZERO
		update_anim(velocity)
		
		

func toggle_selection(value:bool):
	is_selected = value
	selection_icon.visible = value


func update_facing(_dir: float):
	pass

func update_anim(_velocity: Vector2):
	pass
