extends Node2D

var is_dragging:bool = false
var selected_units:Array =[]
var drag_start:Vector2
var selection_rectangle:RectangleShape2D = RectangleShape2D.new()



func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton :
		if event.button_index == MOUSE_BUTTON_LEFT :
			# check si on clique
			if event.pressed :
				# check si on clique sur un objet
				var result = check_if_something_at_position(get_global_mouse_position())
				# non -> deselect les objets sélectionnés
				if result == [] :
					for unit in selected_units :
						unit.collider.get_parent().toggle_selection(false)
					selected_units = []
					# commence le dragging
					is_dragging = true
					drag_start = get_global_mouse_position()
				else :
					# oui -> check si déjà sélectionné
					var is_selected:bool = result[0].collider.get_parent().is_selected
					# si pas sélectionné ou plusieurs units sélectionnées -> sélection unique de l'unit
					if !is_selected or (is_selected and selected_units.size()>1):
						for unit in selected_units :
							unit.collider.get_parent().toggle_selection(false)
						selected_units = []
						result[0].collider.get_parent().toggle_selection(true)
						selected_units.append(result[0])
					# si sélectionné mais unique -> déselection
					elif is_selected and selected_units.size() == 1 :
						selected_units[0].collider.get_parent().toggle_selection(false)
						selected_units = []
						
			# si on lache la souris -> fin du dragging, dessine le rectangle, sélectionne les units dans le rectangle
			elif is_dragging :
				is_dragging = false
				queue_redraw()
				var drag_end = get_global_mouse_position()
				selected_units = rectangular_selection(drag_start,drag_end)
				for unit in selected_units:
					unit.collider.get_parent().toggle_selection(true)
	# si souris en motion et dragging -> dessin du rectangle
	if event is InputEventMouseMotion and is_dragging == true:
		queue_redraw()

func rectangular_selection(from:Vector2, to:Vector2):
	var intercepted_units
	selection_rectangle.extents = (to - from).abs() / 2.0
	var space = get_world_2d().direct_space_state
	var query = PhysicsShapeQueryParameters2D.new()
	query.collide_with_areas = true
	query.collide_with_bodies = false
	query.collision_mask = 1
	query.set_shape(selection_rectangle)
	query.transform = Transform2D(0, (to + from)/2)
	intercepted_units = space.intersect_shape(query)
	#print(intercepted_units)
	return intercepted_units

func check_if_something_at_position(target: Vector2):
	var space = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = target
	query.collide_with_areas = true
	query.collide_with_bodies = false
	#print(query.position)
	var result = space.intersect_point(query)
	return result

func _draw():
	if is_dragging:
		var start = drag_start
		var end = get_global_mouse_position()
		draw_rect(Rect2(start, end - start).abs(),Color.WHITE_SMOKE,false,1.5)
