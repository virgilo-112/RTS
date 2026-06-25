extends CharacterBody2D

var speed = 300
var click_position = Vector2()
var target_position = Vector2()
var mouse_inside = false
var is_selected = false
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var selection_sprite: AnimatedSprite2D = $AreaSelection/SelectionSprite


func _ready() -> void:
	click_position = position
	selection_sprite.set_frame_and_progress(1,1)


func _physics_process(delta: float) -> void:
	select()
	if is_selected and Input.is_action_just_pressed("right_click"):
		click_position = assign_move()
	move(click_position)


func assign_move() -> Vector2:
	click_position = get_global_mouse_position()
	return click_position


func move(pos):

	if position.distance_to(pos) > 3:
			
		navigation_agent.target_position = pos
		var nav_point_direction = to_local(navigation_agent.get_next_path_position()).normalized()
		if navigation_agent.get_next_path_position().x < position.x:
			
			animated_sprite.flip_h = true
		
		else:
			animated_sprite.flip_h = false
			
		velocity = nav_point_direction * speed 
		animated_sprite.play("Run")
		move_and_slide()
	else:
		velocity = Vector2.ZERO
		animated_sprite.play("Idle")
		

func _on_area_selection_mouse_entered() -> void:
	mouse_inside = true


func _on_area_selection_mouse_exited() -> void:
	mouse_inside = false
#test

func select():
	if Input.is_action_just_pressed("left_click"):
		if mouse_inside :
			is_selected = true
			selection_sprite.set_frame_and_progress(0,0)
		elif !mouse_inside :
			is_selected = false
			selection_sprite.set_frame_and_progress(1,1)
