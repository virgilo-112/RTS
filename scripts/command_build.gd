class_name BuildCommand
extends Command

var building : PackedScene
var pos : Vector2

func _init(building_scene, position):
	building = building_scene
	pos = position

func start(unit):
	if not unit.has_ability("build"):
		return
	unit.set_destination(pos)
	unit.reset_action()

func on_arrived(unit):
	unit.start_building(building, pos)

func on_building_tick(unit):
	unit.finish_building(building, pos)
