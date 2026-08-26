extends CanvasLayer

const FOG_RESOLUTION := Vector2i(1000, 600)

var visible_image : Image
var explored_image : Image

var units: Array[Unit] = []

func register_unit(unit: Unit) -> void:
	if unit not in units:
		units.append(unit)
	print(units)
	
	unit.tree_exited.connect(
		func(): unregister_unit(unit),
		CONNECT_ONE_SHOT
	)
	
func unregister_unit(unit: Unit) -> void:
	units.erase(unit)
