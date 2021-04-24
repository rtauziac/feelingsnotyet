extends Node2D


func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.pressed:
			for person in get_children():
				if person is Sprite:
					var person_rect: Rect2 = Rect2(to_global(person.position), person.texture.get_size())
					if person_rect.has_point(get_global_mouse_position()):
						print("%s clicked" % person.name)
