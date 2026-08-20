extends StaticBody2D

class_name Building


@onready var blue_sprite_2d: Sprite2D = $BlueSprite2D
@onready var red_sprite_2d: Sprite2D = $RedSprite2D
@onready var yellow_sprite_2d: Sprite2D = $YellowSprite2D
@onready var black_sprite_2d: Sprite2D = $BlackSprite2D
@onready var purple_sprite_2d: Sprite2D = $PurpleSprite2D

var builders : Array[Pawn] = []
var under_construction : bool = false
var owner_player : Player
var sprite_2d : Sprite2D

func add_builder(pawn: Pawn) -> void:
	if pawn in builders:
		return
	builders.append(pawn)
	start_construction_animation()

func remove_builder(pawn: Pawn) -> void:
	if pawn not in builders:
		return
	builders.erase(pawn)

func finish_construction() -> void:
	under_construction = false
	stop_construction_animation()
	for pawn in builders:
		pawn.stop_building()

	builders.clear()
	
func start_construction_animation() -> void:
	pass
	
func stop_construction_animation() -> void:
	pass

func set_color() -> Sprite2D:
	match owner_player.color :
		"blue":
			sprite_2d = blue_sprite_2d
		"red":
			sprite_2d = red_sprite_2d
		"yellow":
			sprite_2d = yellow_sprite_2d
		"black":
			sprite_2d = black_sprite_2d
		"purple":
			sprite_2d = purple_sprite_2d
	return sprite_2d
