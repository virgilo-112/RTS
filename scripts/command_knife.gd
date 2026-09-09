class_name KnifeCommand
extends Command

var sheep : Sheep

func _init(target):
	sheep = target

func start(unit):
	if not unit.has_ability("knife"):
		return
	unit.set_destination(sheep.global_position)
	unit.reset_action()


func update(unit, _delta):
	if !is_instance_valid(sheep):
		unit.cancel_current_command()
		return

	if unit.knife_area.overlaps_body(sheep):
		unit.stop_moving()
		return


func on_arrived(unit):
	unit.start_knifing(sheep)

func on_knifing_tick(unit):
	if is_instance_valid(sheep):
		var knifed = sheep.knife(1)
		unit.get_owner_player().add_food(knifed)
