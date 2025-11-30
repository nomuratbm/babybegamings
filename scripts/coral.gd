extends Area2D

class_name Coral

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func destroy():
	animated_sprite.play("destroy")

func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite.animation == "destroy":
		queue_free()
