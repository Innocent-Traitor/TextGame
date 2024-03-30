extends CanvasLayer

@onready var line_label : PackedScene = preload("res://line_label.tscn")
@onready var command_line : LineEdit= $CommandLine/LineEdit
@onready var text_history : VBoxContainer = $ScrollContainer/TextHistory
@onready var scroll_container : ScrollContainer = $ScrollContainer

var command_history : Array = []
var command_history_index : int = -1


func _on_line_edit_text_submitted(new_text: String) -> void:
	# Submit the text to Text History
	var edit_text = "> " + new_text
	create_new_line(edit_text)
	command_line.text = ""
	
	handle_command_input(new_text)


func _on_timer_timeout() -> void:
	create_new_line("Joe Mama")

## Creates a new child label, assigns the associated text and
## places it under the text_history VBoxContainer
func create_new_line(text : String, fv : FontVariation = null) -> void:
	var new_line = line_label.instantiate()
	new_line.text = text
	if (fv):
		new_line.add_theme_font_override("font", fv)
	await get_tree().create_timer(0.05).timeout
	text_history.add_child(new_line)


func handle_command_input(text : String) -> void:
	if text == "": return

	var command_text : Array= text.to_lower().split(" ")
	if command_text[0][0] == "!":
		command_text[0] = command_text[0].erase(0, 1)
		handle_debug_input(command_text)
		return
	var found_command = false
	for i in CommandsDB.COMMANDS:
		if command_text[0] == CommandsDB.COMMANDS[i]["name"]:
			print(CommandsDB.COMMANDS[i]["name"])
			found_command = CommandsDB.COMMANDS[i]["name"]
	if !found_command:
		create_new_line("'" + command_text[0] + "'" + " is not a valid command")
	else:
		call(found_command, command_text)
		if (command_history.size() > 10):
			command_history.remove_at(9)
		command_history.push_front(text)
		command_history_index = -1
		print(command_history)


func _input(event) -> void:
	if (event is InputEventKey and event.pressed):
		print(command_history_index)
		if event.keycode == KEY_UP:
			if (command_history.size() > 0) && (command_history_index < command_history.size() - 1):
				command_history_index += 1
				command_line.text = command_history[command_history_index]
		elif event.keycode == KEY_DOWN:
			if (command_history.size() > 0) && (command_history_index > 0):
				command_history_index -= 1
				command_line.text = command_history[command_history_index]




func attack(command_text : Array) -> void:
	command_text.remove_at(0)
	var final_text : String = ""
	for i in command_text:
		final_text += " " + str(i)
	create_new_line("You attacked" + final_text)


func help(_command_text : Array) -> void:
	for i in CommandsDB.COMMANDS:
		create_new_line(str(CommandsDB.COMMANDS[i]["name"]) + " - " + CommandsDB.COMMANDS[i]["description"])

	

func handle_debug_input(command_text : Array) -> void:
	print(command_text)
	match command_text[0]:
		"os":
			command_line.editable = false
			var fv = FontVariation.new()
			fv.spacing_space = 11
			create_new_line('')
			create_new_line('┌ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┐', fv)
			await get_tree().create_timer(0.1).timeout
			create_new_line('│   █████  ███████  ██████  ███    ██      ██████  ███████  │', fv)
			await get_tree().create_timer(0.1).timeout
			create_new_line('│  ██   ██ ██      ██    ██ ████   ██     ██    ██ ██       │', fv)
			await get_tree().create_timer(0.1).timeout
			create_new_line('│  ███████ █████   ██    ██ ██ ██  ██     ██    ██ ███████  │', fv)
			await get_tree().create_timer(0.1).timeout
			create_new_line('│  ██   ██ ██      ██    ██ ██  ██ ██     ██    ██      ██  │', fv)
			await get_tree().create_timer(0.1).timeout
			create_new_line('│  ██   ██ ███████  ██████  ██   ████      ██████  ███████  │', fv)
			await get_tree().create_timer(0.1).timeout
			create_new_line('└ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ┘', fv)
			create_new_line('')
			await get_tree().create_timer(0.5).timeout
			create_new_line('Created by Alfred Eisenbaum')
			await get_tree().create_timer(0.1).timeout
			create_new_line('Published by Sunrock Software')
			await get_tree().create_timer(0.1).timeout
			create_new_line('Copyright 1994-1996 Sunrock Software')
			command_line.editable = true

