extends Unit

class_name Pawn

# =================== parameters =================== #

# --------- Action --------- #

var current_building : Building = null


# =================== functions =================== #

# --------- Build --------- #

func start_building(building_instance, _target: Vector2):
	action = Action.BUILDING
	building_instance.add_builder(self)
	current_building = building_instance


func stop_building() -> void:
	if current_building != null:
		current_building.remove_builder(self)
	action = Action.IDLE
	current_building = null
	update_anim()


# --------- Mine --------- #

func start_mining(stone: GoldStone):
	action = Action.MINING
	if !stone.depleted.is_connected(stop_mining):
		stone.depleted.connect(stop_mining)
	$MiningTimer.start()


func _on_mining_timer_timeout() -> void:
	if current_command is MineCommand:
		current_command.on_mining_tick(self)


func stop_mining():
	action = Action.IDLE
	$MiningTimer.stop()
	update_anim()


# --------- Chop --------- #

func start_choping(tree: WoodTree):
	action = Action.CHOPING
	if !tree.depleted.is_connected(stop_choping):
		tree.depleted.connect(stop_choping)
	$ChopingTimer.start()


func _on_choping_timer_timeout() -> void:
	if current_command is ChopCommand:
		current_command.on_choping_tick(self)


func stop_choping():
	action = Action.IDLE
	$ChopingTimer.stop()
	update_anim()


# --------- Knife --------- #

func start_knifing(sheep: Sheep):
	action = Action.KNIFING
	if !sheep.depleted.is_connected(stop_knifing):
		sheep.depleted.connect(stop_knifing)
	$KnifingTimer.start()


func _on_knifing_timer_timeout() -> void:
	if current_command is KnifeCommand:
		current_command.on_knifing_tick(self)


func stop_knifing():
	action = Action.IDLE
	$KnifingTimer.stop()
	update_anim()


# --------- Reset Action --------- #

func reset_action():
	match action :
		Action.KNIFING:
			stop_knifing()
		Action.MINING:
			stop_mining()
		Action.CHOPING:
			stop_choping()
		Action.BUILDING:
			stop_building()


func cancel_current_command() -> void:
	current_command = null
	navigation_agent.target_position = global_position


# --------- Animation --------- #

func update_anim():
	if animated_sprite == null:
		return

	var animation_name: String

	match action:
		Action.MOVING:
			animation_name = "Run"
		Action.MINING:
			animation_name = "Pickaxe_Interact"
		Action.CHOPING:
			animation_name = "Axe_Interact"
		Action.KNIFING:
			animation_name = "Knife_Interact"
		Action.BUILDING:
			animation_name = "Hammer_Interact"
		_:
			animation_name = "Idle"

	if animated_sprite.animation != animation_name:
		animated_sprite.play(animation_name)

func toggle_selection(value:bool):
	super.toggle_selection(value)
	$UIPawn.visible = value
