extends Panel

const pnk = "#d47896"
const red = "#b8545e"
const pur = "#b685d1"
const cya = "#8bcdca"
const ylw = "#decc73"
const grn = "#89a350"

var text_inside_grid = "
[color="+cya+"]Pos: [/color]x:%d y:%d
[color="+ylw+"]Inv: [/color]%d/%d
[color="+grn+"]%s [/color]
[color="+pur+"]Vazio:[/color] %s
[color="+pur+"]Seco:[/color] %s
[color="+pur+"]Maduro:[/color] %s"

var text_outside_grid = "
[color="+cya+"]Pos:[/color][color="+red+"]		-[/color]
[color="+ylw+"]Inv: [/color]%d/%d
[color="+red+"]-[/color]
[color="+pur+"]Vazio:[/color][color="+red+"]	-[/color]
[color="+pur+"]Seco:[/color][color="+red+"]	-[/color]
[color="+pur+"]Maduro:[/color][color="+red+"]	-[/color]
"
@onready var console = $Margins/VBox/Console

func _ready():
	#Events.update_stat_text.connect(_update_stat_text)
	pass

func _update_stat_text(stats:Array) -> void:
	if stats[8] == true: # robot is outside the grid
		console.text = text_outside_grid % [stats[2],stats[3]]
	else :
		stats.resize(8)
		stats[5] = (
			"[color="+grn+"]"+str(stats[5])+"[/color]") if stats[5] else (
			"[color="+red+"]"+str(stats[5])+"[/color]")
		stats[6] = (
			"[color="+grn+"]"+str(stats[6])+"[/color]") if stats[6] else (
			"[color="+red+"]"+str(stats[6])+"[/color]")
		stats[7] = (
			"[color="+grn+"]"+str(stats[7])+"[/color]") if stats[7] else (
			"[color="+red+"]"+str(stats[7])+"[/color]")
		console.text = text_inside_grid % stats
	# [pos x, pos y, inv_left, inv_max, slot_seed, is_empty, is_dry, is_grown, outside_grid]
