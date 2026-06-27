extends Unit

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	click_position = position
	selection_icon.visible = false


func _physics_process(_delta: float) -> void:
	select()
	if is_selected and Input.is_action_just_pressed("right_click"):
		click_position = assign_move()
	move(click_position)

func update_facing(dir):
	animated_sprite_2d.flip_h = dir < 0

func update_anim(vel):
	if vel != Vector2.ZERO :
		animated_sprite_2d.play("Run")
	else :
		animated_sprite_2d.play("Idle")
