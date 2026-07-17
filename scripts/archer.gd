extends Unit

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export var abilities: Array[String] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	selection_icon.visible = false

func has_ability(ability: String) -> bool:
	return ability in abilities

func _physics_process(_delta: float) -> void:
	move()

func update_facing(dir):
	animated_sprite_2d.flip_h = dir < 0

func update_anim():
	if velocity != Vector2.ZERO :
		animated_sprite_2d.play("Run")
	else :
		animated_sprite_2d.play("Idle")
