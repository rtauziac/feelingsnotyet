extends Node2D


export (float) var parralax_amount = 0.2
var _prev_x: float = 0.0

func _process(_delta):
	var x = float(get_viewport().get_mouse_position().x - get_viewport().size.x / 2)
	var _amount = lerp(_prev_x, x, 0.35)
	for child in get_children():
		if child is ParralaxElement:
			child.set_parralax(_amount * parralax_amount)
	_prev_x = _amount
