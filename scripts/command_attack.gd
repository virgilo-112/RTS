class_name AttackCommand
extends Command

var enemy : Node2D

func _init(target):
	if target is Unit or target is Building:
		enemy = target
	else:
		return

var last_target_position := Vector2.ZERO

func start(unit):
	if not unit.has_ability("attack"):
		return

	last_target_position = enemy.get_closest_point(unit.global_position)
	unit.set_destination(last_target_position)
	unit.reset_action()


func update(unit, _delta):
	if !is_instance_valid(enemy):
		unit.cancel_current_command()
		return

	var target_position = enemy.get_closest_point(unit.global_position)

	if target_position.distance_to(last_target_position) > 10.0:
		last_target_position = target_position
		unit.set_destination(target_position)

func on_arrived(unit):
	if !is_instance_valid(enemy):
		return
	unit.start_attack(enemy)


func deal_damage():
	if is_instance_valid(enemy):
		enemy.take_damage(10)
