class_name AttackCommand
extends Command

var enemy : Unit
var last_target_position := Vector2.ZERO


func _init(target):
	enemy = target


func start(unit):
	if not unit.has_ability("attack"):
		return
	last_target_position = enemy.global_position
	unit.set_destination(last_target_position)
	unit.reset_action()


func update(unit, _delta):
	if !is_instance_valid(enemy):
		unit.cancel_current_command()
		return

	if unit.attack_area.overlaps_body(enemy):
		unit.stop_moving()
		return

	var target_position := enemy.global_position

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
