extends Node2D

class_name Raycasts

@onready var right_horizontal_raycasts: Array[RayCast2D] = [
	$Horizontal/Right/RightHorizontalBottom,
	$Horizontal/Right/RightHorizontalTop
]
@onready var left_horizontal_raycasts: Array[RayCast2D] = [
	$Horizontal/Left/LeftHorizontalBottom,
	$Horizontal/Left/LeftHorizontalTop
]
@onready var top_vertical_raycasts: Array[RayCast2D] = [
	$Vertical/Top/TopVerticalRight,
	$Vertical/Top/TopVerticalLeft
]
@onready var bottom_vertical_raycasts: Array[RayCast2D] = [
	$Vertical/Bottom/BottomVerticalRight,
	$Vertical/Bottom/BottomVerticalLeft
]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func check_collisions() -> Array[Vector2]:
	var collisions: Array[Vector2] = []
	
	var is_left_colliding = left_horizontal_raycasts.reduce(is_raycast_colliding, false)
	var is_right_colliding = right_horizontal_raycasts.reduce(is_raycast_colliding, false)
	var is_top_colliding = top_vertical_raycasts.reduce(is_raycast_colliding, false)
	var is_bottom_colliding = bottom_vertical_raycasts.reduce(is_raycast_colliding, false)
	
	if is_left_colliding:
		collisions.append(Vector2.LEFT)
	if is_right_colliding:
		collisions.append(Vector2.RIGHT)
	if is_top_colliding:
		collisions.append(Vector2.UP)
	if is_bottom_colliding:
		collisions.append(Vector2.DOWN)
	
	return collisions

func is_raycast_colliding(acc: bool, next: RayCast2D):
	return next.is_colliding() || acc
