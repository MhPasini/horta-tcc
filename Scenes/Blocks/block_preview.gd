extends Label
class_name  BlockPreview

const b_font = preload("res://Fonts/TinyUnicode.ttf")
const b_style = preload("res://UI/Styles/block_preview.tres")
const font_color = Globals.block_font_color

func _init(b_text: String, b_color: Color):
	add_theme_font_override("font", b_font)
	add_theme_stylebox_override("normal", b_style)
	add_theme_color_override("font_color", font_color)
	get_theme_stylebox("normal").set("bg_color", b_color)
	text = b_text
