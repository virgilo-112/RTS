class_name DestroyCommand
extends Command

var building : Building

func _init(target):
	building = target

func start(unit):
	if not unit.has_ability("attack"):
		return
	unit.set_destination(building.global_position)
	unit.reset_action()


func update(unit, _delta):
	if !is_instance_valid(building):
		unit.cancel_current_command()
		return

	if unit.attack_area.overlaps_area(building.area_2d):
		unit.stop_moving()
		return


func on_arrived(unit):
	if !is_instance_valid(building):
		return
	unit.start_attack(building)


func deal_damage():
	if is_instance_valid(building):
		building.take_damage(10)
