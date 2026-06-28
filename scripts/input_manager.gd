extends Node2D

var is_dragging:bool = false
var selected_units:Array =[]
var drag_start:Vector2
var selection_rectangle:RectangleShape2D = RectangleShape2D.new()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton :
		if event.button_index == MOUSE_BUTTON_LEFT :
			if event.pressed :
				# if 

func rectangular_selection(from:Vector2, to:Vector2):
	var intercepted_units
	selection_rectangle.extents = (to - from)/2
	var space = get_world_2d().direct_space_state
	var query = Physics2DShapeQueryParameters.new()
	#Because my Units are Area2d
	query.collide_with_areas = true
	#Assing the RectangleShape2D
	query.set_shape(selection_rectangle)
	#Position
	query.transform = Transform2D(0, (to + from)/2)
	#Selected units will be those intersected by the RectangleShape2D
	intercepted_units = space.intersect_shape(query)
	return intercepted_units

func _draw():
	#Draws selection rectangle only if dragging
	if is_dragging == true:
		draw_rect(Rect2(drag_start,get_global_mouse_position() - drag_start),Color.WHITE_SMOKE,false,1.5,false)
