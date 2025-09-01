extends Node

const MSG_TYPE = {
	"normal": "",
	"warning": "[color=yellow]AVISO: [/color]",
	"error": "[color=red]ERRO: [/color]"
}

const carrot_sprite : Texture = preload("res://Textures/crops/carrot.png")
const onion_sprite : Texture = preload("res://Textures/crops/onion.png")
const radish_sprite : Texture = preload("res://Textures/crops/radish.png")

#Colors
const block_font_color = Color("575757")
#const method_color = Color("9ec9d9")
#const loop_color = Color("9ec9d9")
#const while_color = Color("9ec9d9")
#const if_color = Color("9ec9d9")
#const function_color = Color("9ec9d9")

var robot_ref : RobotClass
