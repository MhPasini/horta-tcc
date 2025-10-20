extends Panel


const MAX_LINES = 200
@onready var console = $Margins/VBox/Console

func _ready():
	clear_console()
	Events.console_message.connect(add_console_message)
	Globals.console = self

func add_console_message(message: String) -> void:
	console.append_text("> " + message + "\n")
	var line_count = console.get_line_count()
	if line_count > MAX_LINES:
		var text: String = console.text
		var lines = text.split("\n")
		console.text = "\n".join(lines.slice(line_count - MAX_LINES))

func clear_console() -> void:
	console.clear()
	add_console_message("Console Iniciado!")

func _on_clear_btn_pressed():
	console.clear()
