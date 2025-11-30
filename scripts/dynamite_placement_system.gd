extends Node

class_name DynamitePlacementSystem

const DYNAMITE_SCENE = preload("res://scenes/dynamite.tscn")
const TILE_SIZE = 16

var player: Player = null
var dynamites_placed = 0
var explosion_size = 1

func _ready() -> void:
	player = get_parent()

func place_dynamite():
	if dynamites_placed == player.max_dynamites_at_once:
		return
	
	var dynamite = DYNAMITE_SCENE.instantiate()
	var player_position = player.position
	var dynamite_position = Vector2(round(player_position.x / TILE_SIZE) * TILE_SIZE, 
		round(player_position.y / TILE_SIZE) * TILE_SIZE)
	
	dynamite.position = dynamite_position
	get_tree().root.add_child(dynamite)
	dynamites_placed += 1
	dynamite.tree_exiting.connect(on_dynamite_exploded)

func on_dynamite_exploded():
	dynamites_placed -= 1
