extends Area2D

class_name PowerUp

@onready var sprite: Sprite2D = $Sprite2D

var type: Utils.PowerUpType

func init(power_up_res: PowerUpRes):
	sprite.texture = power_up_res.texture
	type = power_up_res.type
