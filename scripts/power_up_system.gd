extends Node

class_name PowerUpSystem

@onready var animated_sprite: AnimatedSprite2D = %AnimatedSprite2D
@onready var dynamite_placement_system: DynamitePlacementSystem = $"../DynamitePlacementSystem"
@onready var dynamite_up_timer: Timer = $DynamiteUpTimer
@onready var fire_up_timer: Timer = $FireUpTimer

var player: Player

func _ready() -> void:
	player = get_parent()

func enable_power_up(power_up_type: Utils.PowerUpType):
	match power_up_type:
		Utils.PowerUpType.DYNAMITE_UP:
			player.max_dynamites_at_once += 1
			dynamite_up_timer.start()
		Utils.PowerUpType.FIRE_UP:
			dynamite_placement_system.explosion_size += 1
			fire_up_timer.start()

func _on_dynamite_up_timer_timeout() -> void:
	if(player.max_dynamites_at_once > 1):
		player.max_dynamites_at_once -= 1

func _on_fire_up_timer_timeout() -> void:
	if(dynamite_placement_system.explosion_size > 1):
		dynamite_placement_system.explosion_size -= 1
