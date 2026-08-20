extends Unit

class_name Pawn


@export var abilities: Array[String] = []

var is_mining : bool = false
var is_choping : bool = false
var is_knifing : bool = false
var is_building : bool = false

@onready var mining_timer: Timer = $MiningTimer
@onready var choping_timer: Timer = $ChopingTimer
@onready var knifing_timer: Timer = $KnifingTimer
@onready var building_timer: Timer = $BuildingTimer

@onready var ui_pawn: CanvasLayer = $UIPawn
@onready var hp_label: Label = $UIPawn/Control/PanelContainer/HBoxContainer/HPLabel

@export var hp: int

var current_building : Building = null


func _ready() -> void:
	super._ready()
	selection_icon.visible = false
	hp_label.text = "Health : "+str(hp)
	set_color().visible = true
	print(abilities)


func _physics_process(_delta: float) -> void:
	move()

func has_ability(ability: String) -> bool:
	return ability in abilities


func update_facing(dir):
	animated_sprite.flip_h = dir < 0

func update_anim():
	if velocity != Vector2.ZERO :
		animated_sprite.play("Run")
	elif velocity == Vector2.ZERO and is_mining :
		animated_sprite.play("Pickaxe_Interact")
	elif velocity == Vector2.ZERO and is_choping :
		animated_sprite.play("Axe_Interact")
	elif velocity == Vector2.ZERO and is_knifing :
		animated_sprite.play("Knife_Interact")
	elif velocity == Vector2.ZERO and is_building :
		animated_sprite.play("Hammer_Interact")
	else :
		animated_sprite.play("Idle")
		
func toggle_selection(value:bool):
	super.toggle_selection(value)
	ui_pawn.visible = value

func start_building(building_instance, _target: Vector2):
	is_building = true
	building_instance.add_builder(self)
	current_building = building_instance
	
func stop_building() -> void:
	if current_building != null:
		current_building.remove_builder(self)
	is_building = false
	current_building = null
	cancel_current_command()
	update_anim()

func start_mining(stone: GoldStone):
	is_mining = true
	if !stone.depleted.is_connected(stop_mining):
		stone.depleted.connect(stop_mining)
	mining_timer.start()

func _on_mining_timer_timeout() -> void:
	if current_command is MineCommand:
		current_command.on_mining_tick(self)

func stop_mining():
	is_mining = false
	mining_timer.stop()
	cancel_current_command()
	update_anim()


func start_choping(tree: WoodTree):
	is_choping = true
	if !tree.depleted.is_connected(stop_choping):
		tree.depleted.connect(stop_choping)
	choping_timer.start()


func _on_choping_timer_timeout() -> void:
	if current_command is ChopCommand:
		current_command.on_choping_tick(self)

func stop_choping():
	is_choping = false
	choping_timer.stop()
	cancel_current_command()
	update_anim()

func start_knifing(sheep: Sheep):
	is_knifing = true
	if !sheep.depleted.is_connected(stop_knifing):
		sheep.depleted.connect(stop_knifing)
	knifing_timer.start()


func _on_knifing_timer_timeout() -> void:
	if current_command is KnifeCommand:
		current_command.on_knifing_tick(self)
	
func stop_knifing():
	is_knifing = false
	knifing_timer.stop()
	cancel_current_command()
	update_anim()

func reset_action():
	if is_knifing :
		stop_knifing()
	if is_mining :
		stop_mining()
	if is_choping :
		stop_choping()
	if is_building :
		stop_building()
		
func cancel_current_command() -> void:
	current_command = null
	navigation_agent.target_position = global_position
