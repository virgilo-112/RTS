extends Node2D


# =================== parameters =================== #

# --------- Selection tool --------- #
var drag_start:Vector2
var is_dragging:bool = false
var selected_objects:Array =[]
var selection_rectangle:RectangleShape2D = RectangleShape2D.new()
var player_id : int

# =================== Functions =================== #

# --------- Disabling selection tool --------- #

func set_enabled(value: bool) -> void:
	set_process_input(value)
	set_process_unhandled_input(value)


func setup(player: Player):
	player_id = player.player_id

# --------- Input --------- #

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			selection(event)

		elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			var target : Node2D = object_at_position(get_global_mouse_position())
			var mouse_pos = get_global_mouse_position()
			issue_command(target, mouse_pos)

	if event is InputEventMouseMotion and is_dragging:
		queue_redraw()


# --------- Issue command --------- #

func issue_command(target: Node2D, mouse_pos: Vector2) -> void:
	for object in selected_objects:
		if !is_instance_valid(object):
			return
		if not object.can_receive_command():
			continue
		if object is Unit :
			var unit : Unit = object
			if target == null:
				if unit.has_ability("move"):
					GameManager.request_move.rpc_id(1, player_id, unit.get_path(), mouse_pos)
					
			if target is GoldStone:
				if unit.has_ability("mine"):
					GameManager.request_mine.rpc_id(1, player_id, unit.get_path(), target.get_path())
					
			if target is WoodTree:
				if unit.has_ability("chop"):
					GameManager.request_chop.rpc_id(1, player_id, unit.get_path(), target.get_path())
					
			if target is Sheep:
				if unit.has_ability("knife"):
					GameManager.request_knife.rpc_id(1, player_id, unit.get_path(), target.get_path())
					
			if target is Building and unit.get_owner_player() == target.get_owner_player():
				if unit.has_ability("build"):
					GameManager.request_build.rpc_id(1, player_id, unit.get_path(), target.get_path())
					
			if target is Building and unit.get_owner_player() != target.get_owner_player():
				if unit.has_ability("attack"):
					GameManager.request_attack_building.rpc_id(1, player_id, unit.get_path(), target.get_path())
					
			if target is Unit:
				if unit.has_ability("attack"):
					GameManager.request_attack_unit.rpc_id(1, player_id, unit.get_path(), target.get_path())


# --------- Selection tool --------- #

func selection(event) -> void:
	selected_objects = selected_objects.filter(is_instance_valid)
	var can_interact := false
	if event.pressed :
		# check si on clique sur un objet
		var result = object_at_position(get_global_mouse_position())
		# non -> deselect les objets sélectionnés
		if result == null :
			for object in selected_objects :
				if is_instance_valid(object):
					object.toggle_selection(false, false)
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
					if is_instance_valid(object):
						object.toggle_selection(false, false)
				selected_objects = []
				if is_instance_valid(result):
					if result is Unit or result is Building :
						can_interact = result.player_id == player_id
				result.toggle_selection(true, can_interact)
				selected_objects.append(result)
			# si sélectionné mais unique -> déselection
			elif is_selected and selected_objects.size() == 1 :
				if is_instance_valid(selected_objects[0]):
					selected_objects[0].toggle_selection(false, false)
				selected_objects = []
	# si on lache la souris -> fin du dragging, dessine le rectangle, sélectionne les units dans le rectangle
	elif is_dragging :
		is_dragging = false
		queue_redraw()
		var drag_end = get_global_mouse_position()
		selected_objects = rectangular_selection(drag_start,drag_end)
		for object in selected_objects:
			if is_instance_valid(object):
				if object is Unit or object is Building :
					can_interact = object.player_id == player_id
			object.toggle_selection(true, can_interact)


# --------- Selection tool colliding --------- #

func object_at_position(target: Vector2) -> Node2D :
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


func rectangular_selection(from:Vector2, to:Vector2) -> Array[Unit]:
	var intercepted_units : Array[Unit] = []

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


# --------- Selection tool visual --------- #

func _draw() -> void :
	if is_dragging:
		var start = drag_start
		var end = get_global_mouse_position()
		draw_rect(Rect2(start, end - start).abs(),Color.WHITE,false,5.5)
