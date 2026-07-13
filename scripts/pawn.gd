extends Unit

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var is_pickaxing : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	selection_icon.visible = false


func _physics_process(_delta: float) -> void:
	if is_selected and Input.is_action_just_pressed("right_click"):
		assign_move()
	move()

func update_facing(dir):
	animated_sprite_2d.flip_h = dir < 0

func update_anim():
	if velocity != Vector2.ZERO :
		animated_sprite_2d.play("Run")
	elif velocity == Vector2.ZERO and is_pickaxing :
		animated_sprite_2d.play("Pickaxe_Interact")
	else :
		animated_sprite_2d.play("Idle")


func interact_gold():
	is_pickaxing = true
