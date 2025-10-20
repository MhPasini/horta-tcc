extends Control

var tween_time = 0.8
var lb_text : String = ""

func _ready():
	$P_b/VBoxContainer/Label.text = lb_text
	var t = create_tween()
	modulate.a = 0.0
	t.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	t.tween_property(self, "modulate:a", 1.0, tween_time)
	await t.finished
	terminate_self(1.6)

func terminate_self(time_s:float) -> void:
	await create_tween().tween_interval(time_s).finished
	
	var t = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	t.tween_property(self, "modulate:a", 0.0, 0.4)
	await t.finished
	queue_free()
