class_name Character
extends Node

enum Name {
	DINA,
	FISHCAYA
}

const CHARACTER_DETAILS : Dictionary = {
	Name.DINA: {
		"name": "Dina",
		"role": "main",
		"sprite_frames": preload("res://resources/aling_dina.tres")
	},
	Name.FISHCAYA: {
		"name": "Fishcaya",
		"role": "side",
		"sprite_frames": preload("res://resources/tilapia.tres")
	}
}

static func get_enum_from_string(string_value : String) -> int:
	var upper_string = string_value.to_upper()
	if Name.has(upper_string):
		return Name[upper_string]
	else:
		push_error("Invalid Character name: " + string_value)
		return -1
