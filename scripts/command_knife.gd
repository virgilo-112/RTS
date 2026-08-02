class_name KnifeCommand
extends Command

var sheep : Sheep

func _init(target):
	sheep = target

func start(unit):
	if not unit.has_ability("knife"):
		return
	unit.set_destination(sheep.get_closest_point(unit.global_position))
	unit.reset_action()

func on_arrived(unit):
	unit.start_knifing()
