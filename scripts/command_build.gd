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

func update(unit, _delta):
	if !is_instance_valid(building):
		unit.cancel_current_command()
		return

	if unit.hammer_area.overlaps_body(building):
		unit.stop_moving()
		return


func on_arrived(unit):
	unit.start_building(building, pos)
