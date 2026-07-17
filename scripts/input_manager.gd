extends Node2D

var is_dragging:bool = false
var selected_objects:Array =[]
var drag_start:Vector2
var selection_rectangle:RectangleShape2D = RectangleShape2D.new()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton :
		if event.button_index == MOUSE_BUTTON_LEFT :
			selection(event)
			
		elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			if check_if_something_at_position(get_global_mouse_position()) == null :
				var mouse_pos = get_global_mouse_position()
				for object in selected_objects:
					if object.can_receive_command():
						object.assign_command(MoveCommand.new(mouse_pos))
			else :
				var mouse_pos = get_global_mouse_position()
				for object in selected_objects:
					if object.can_receive_command():
						object.assign_command(MineCommand.new(check_if_something_at_position(mouse_pos)))
				
				
	# si souris en motion et dragging -> dessin du rectangle
	if event is InputEventMouseMotion and is_dragging == true:
		queue_redraw()
		
		
		
		
func selection(event):
	if event.pressed :
		# check si on clique sur un objet
		var result = check_if_something_at_position(get_global_mouse_position())
		# non -> deselect les objets sélectionnés
		if result == null :
			for object in selected_objects :
				object.toggle_selection(false)
			selected_objects = []
			# commence le dragging
			is_dragging = true
			drag_start = get_global_mouse_position()
		else :
			# oui -> check si déjà sélectionné
			var is_selected:bool = result.is_selected
			# si pas sélectionné ou plusieurs units sélectionnées -> sélection unique de l'unit
			if !is_selected or (is_selected and selected_objects.size()>1):
				for object in selected_objects :
					object.toggle_selection(false)
				selected_objects = []
				result.toggle_selection(true)
				selected_objects.append(result)
			# si sélectionné mais unique -> déselection
			elif is_selected and selected_objects.size() == 1 :
				selected_objects[0].toggle_selection(false)
				selected_objects = []
	# si on lache la souris -> fin du dragging, dessine le rectangle, sélectionne les units dans le rectangle
	elif is_dragging :
		is_dragging = false
		queue_redraw()
		var drag_end = get_global_mouse_position()
		selected_objects = rectangular_selection(drag_start,drag_end)
		for object in selected_objects:
			object.toggle_selection(true)

func rectangular_selection(from:Vector2, to:Vector2):
	var intercepted_units = []

	selection_rectangle.extents = (to - from).abs() / 2.0

	var space = get_world_2d().direct_space_state
	var query = PhysicsShapeQueryParameters2D.new()

	query.collide_with_areas = true
	query.collide_with_bodies = false
	query.collision_mask = 1
	query.set_shape(selection_rectangle)
	query.transform = Transform2D(0, (to + from)/2)

	var results = space.intersect_shape(query)

	for result in results:
		var object = result.collider.owner

		if object is Unit:
			intercepted_units.append(object)

	return intercepted_units

func check_if_something_at_position(target: Vector2):
	var space = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()

	query.position = target
	query.collide_with_areas = true

	var results = space.intersect_point(query)

	if results.size() > 0:
		var node = results[0].collider

		while node != null:
			if node.has_method("toggle_selection"):
				return node
			node = node.get_parent()

	return null

func _draw():
	if is_dragging:
		var start = drag_start
		var end = get_global_mouse_position()
		draw_rect(Rect2(start, end - start).abs(),Color.WHITE_SMOKE,false,1.5)
