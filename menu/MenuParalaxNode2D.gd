extends Node2D


export (float) var parralax_amount = 0.2


func _process(_delta):
	var x = get_viewport().get_mouse_position().x - get_viewport().size.x / 2
	print(x)
	for child in get_children():
		if child is ParralaxElement:
			child.set_parralax(x * 0.2)
