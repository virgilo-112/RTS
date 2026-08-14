class_name BuildCommand
extends Command

var building
var pos : Vector2

func _init(building_instance, position):
	building = building_instance
	pos = position

func start(unit):
	if not unit.has_ability("build"):
		return
	unit.set_destination(pos)
	unit.reset_action()

func on_arrived(unit):
	unit.start_building(building, pos)
