extends Node2D


func set_smog_for_person(the_person: Person):
	var all_friends: Array = the_person.siblings
	for person in get_children():
		if person is Person:
			var is_friend = all_friends.has(person)
			var is_self = person == the_person
			person.material.set("shader_param/smogFactor", 0 if (is_friend or is_self) else 0.2)


func remove_smog():
		for person in get_children():
			if person is Person:
				person.material.set("shader_param/smogFactor", 0)


func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.pressed:
			var children: Array = get_children()
			for x in children.size():
				var person = children[-x+1]
				if person is Person:
					var person_rect: Rect2 = Rect2(to_global(person.position), person.texture.get_size())
					if person_rect.has_point(get_global_mouse_position()):
#						print("%s clicked" % person.name)
						set_smog_for_person(person)
						get_tree().set_input_as_handled()
						break
			if not get_tree().is_input_handled():
				get_tree().set_input_as_handled()
				remove_smog()
