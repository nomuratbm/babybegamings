extends Area2D

class_name Player
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var raycasts: Raycasts = $Raycasts
@onready var dynamite_placement_system: Node = $DynamitePlacementSystem
@onready var power_up_system: Node = $PowerUpSystem

@export var movement_speed: float = 75

var movement: Vector2 = Vector2.ZERO
var max_dynamites_at_once = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	var collisions = raycasts.check_collisions()
	
	if collisions.has(movement):
		return
	
	position += movement * delta * movement_speed

func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("right"):
		movement = Vector2.RIGHT
		animated_sprite.play("walk_right")
	elif Input.is_action_pressed("left"):
		movement = Vector2.LEFT
		animated_sprite.play("walk_left")
	elif Input.is_action_pressed("down"):
		movement = Vector2.DOWN
		animated_sprite.play("walk_down")
	elif Input.is_action_pressed("up"):
		movement = Vector2.UP
		animated_sprite.play("walk_up")
	elif Input.is_action_pressed("place_dynamite"):
		dynamite_placement_system.place_dynamite()
	else:
		movement = Vector2.ZERO
		animated_sprite.stop()

func die():
	animated_sprite.play("die")
	movement = Vector2.ZERO
	set_process_input(false)


func _on_area_entered(area: Area2D) -> void:
	if area is PowerUp:
		power_up_system.enable_power_up((area as PowerUp).type)
		area.queue_free()
