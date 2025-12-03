extends Area2D

class_name DirectionalExplosion
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func play_animation(animation_name: String):
	animated_sprite.play(animation_name)

func _on_area_entered(area: Area2D) -> void:
	if area is Player:
		(area as Player).die()
	
	if area is Enemy:
		(area as Enemy).die()
