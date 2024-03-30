extends CanvasLayer

@onready var line_label : PackedScene = preload("res://line_label.tscn")
@onready var command_line : LineEdit= $CommandLine/LineEdit
@onready var text_history : VBoxContainer = $ScrollContainer/TextHistory
@onready var scroll_container : ScrollContainer = $ScrollContainer


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
func create_new_line(text : String) -> void:
	var new_line = line_label.instantiate()
	new_line.text = text
	text_history.add_child(new_line)


func handle_command_input(text : String) -> void:
	var command_text : Array= text.to_lower().split(" ")
	var found_command = false
	for i in CommandsDB.COMMANDS:
		if command_text[0] == CommandsDB.COMMANDS[i]["name"]:
			print(CommandsDB.COMMANDS[i]["name"])
			found_command = CommandsDB.COMMANDS[i]["name"]
	if !found_command:
		create_new_line("'" + command_text[0] + "'" + " is not a valid command")
	else:
		call(found_command, command_text)


func attack(command_text : Array) -> void:
	command_text.remove_at(0)
	var final_text : String = ""
	for i in command_text:
		final_text += " " + str(i)
	create_new_line("You attacked" + final_text)
	
	
