extends Node2D

@onready var background: TextureRect = %Background
@onready var main_character_sprite: Node2D = %MainCharacterSprite
@onready var side_character_sprite: Node2D = %SideCharacterSprite
@onready var dialog_ui: Control = %DialogUI
@onready var voice_player: AudioStreamPlayer = $VoicePlayer

var scene_file : String = ""
var transition_effect : String = "fade"
var dialog_lines : Array = []
var dialog_index : int = 0

func _ready() -> void:
	dialog_lines = load_dialog("res://resources/story/af3_l1.json")
	dialog_ui.text_animation_done.connect(_on_text_animation_done)
	
	SceneManager.transition_out_completed.connect(_on_transition_out_completed)
	SceneManager.transition_in_completed.connect(_on_transition_in_completed)
	
	main_character_sprite.visible = false
	side_character_sprite.visible = false
	
	dialog_index = 0
	process_current_line()

func _input(event):
	var line = dialog_lines[dialog_index]
	var has_choices = line.has("choices")
	if event.is_action_pressed("next_line") and not has_choices:
		if dialog_ui.animate_text:
			dialog_ui.skip_text_animation()
		else:
			if dialog_index < len(dialog_lines) - 1:
				dialog_index += 1
				process_current_line()

func process_current_line():
	if dialog_index >= dialog_lines.size() or dialog_index < 0:
		printerr("Error: dialog_index out of bounds: ", dialog_index)
		return
	
	var line = dialog_lines[dialog_index]
	
	if line.has("next_scene"):
		var next_scene = line["next_scene"]
		scene_file = "res://scenes/" + next_scene + ".tscn" if !next_scene.is_empty() else ""
		transition_effect = line.get("transition", "fade")
		SceneManager.transition_out(transition_effect)
		return
	
	if line.has("location"):
		var background_file = "res://assets/images/" + line["location"] + ".png"
		background.texture = load(background_file)
		
		dialog_index += 1
		process_current_line()
		return
	
	if line.has("goto"):
		dialog_index = get_anchor_position(line["goto"])
		process_current_line()
		return
	
	if line.has("anchor"):
		dialog_index += 1
		process_current_line()
		return
	
	if line.has("speaker"):
		var character_name = Character.get_enum_from_string(line["speaker"])
		position_character(character_name, line.get("expression", ""))
	
	if line.has("voiceline"):
		var voiceline_file = "res://assets/voicelines/" + line["voiceline"] + ".mp3"
		play_voiceline(voiceline_file)
	
	if line.has("choices"):
		dialog_ui.display_choices(line["choices"])
	else:
		var character_name = Character.get_enum_from_string(line["speaker"])
		dialog_ui.change_line(character_name, line["text"])

func position_character(character_name: Character.Name, expression: String = ""):
	var character_details = Character.CHARACTER_DETAILS[character_name]
	var role = character_details["role"]
	
	if role == "main":
		main_character_sprite.visible = true
		main_character_sprite.change_character(character_name, true, expression)
		main_character_sprite.modulate = Color.WHITE
		
		if side_character_sprite.visible:
			side_character_sprite.modulate = Color(0.6, 0.6, 0.6)
			
	else:
		side_character_sprite.visible = true
		side_character_sprite.change_character(character_name, true, expression)
		side_character_sprite.modulate = Color.WHITE
		
		if main_character_sprite.visible:
			main_character_sprite.modulate = Color(0.6, 0.6, 0.6)

func get_anchor_position(anchor: String):
	for i in range(dialog_lines.size()):
		if dialog_lines[i].has("anchor") and dialog_lines[i]["anchor"] == anchor: 
			return i;
	
	printerr("Error: Could not find anchor: '" + anchor + "'")
	return null

func load_dialog(file_path):
	if not FileAccess.file_exists(file_path):
		printerr("Error: File does not exist: ", file_path)
		return null
		
	# Open the file
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		printerr("Error: File does not exist: ", file_path)
		return null
		
	# Read the content of the JSON file
	var content = file.get_as_text()
	# Parse the JSON
	var json_content = JSON.parse_string(content)
	if json_content == null:
		printerr("Error: Failed to parse JSON from file: ", file_path)
		return null
	
	return json_content

func play_voiceline(voiceline_path: String):
	if voice_player.playing:
		voice_player.stop()
	
	if FileAccess.file_exists(voiceline_path):
		voice_player.stream = load(voiceline_path)
		voice_player.play()
	else:
		push_warning("Voiceline file not found: " + voiceline_path)

func _on_text_animation_done():
	var line = dialog_lines[dialog_index]
	if line.has("speaker"):
		var character_name = Character.get_enum_from_string(line["speaker"])
		var character_details = Character.CHARACTER_DETAILS[character_name]
		
		if character_details["role"] == "main":
			main_character_sprite.play_idle_animation()
		else:
			side_character_sprite.play_idle_animation()

func _on_transition_out_completed():
	# Load new dialog
	if !scene_file.is_empty():
		dialog_index = 0
		get_tree().change_scene_to_file(scene_file)
		SceneManager.transition_in(transition_effect)
	else:
		print("End")

func _on_transition_in_completed():
	# Start processing dialog
	process_current_line()
