extends Node2D


var _current_person: Person = null


func focus_person(the_person: Person):
	set_smog_for_person(the_person)


func set_smog_for_person(the_person: Person):
	var all_friends: Array = the_person.siblings
	for person in get_children():
		if person is Person:
			var is_friend = all_friends.has(person)
			var is_self = person == the_person
			person.fog = is_friend or is_self


func remove_smog():
		for person in get_children():
			if person is Person:
				person.material.set("shader_param/smogFactor", 0)


func _process_persons():
	var children: Array = get_children()
	for x in children.size():
		var person = children[-x+1]
		if person is Person:
			var person_available = false
			if (_current_person == null):
				person_available = person.is_open
			else:
				person_available = _current_person.siblings.has(person) or person == _current_person
			if person_available:
				var person_rect: Rect2 = Rect2(to_global(person.position), person.get_size())
				if person_rect.has_point(get_global_mouse_position()):
#						print("%s clicked" % person.name)
					get_tree().set_input_as_handled()
					_current_person = person
					focus_person(person)
					var devil: Devil = person.get_node_or_null("Devil")
					if devil != null:
						devil.visible = true
						devil.start_shards()
					break
	if not get_tree().is_input_handled():
		get_tree().set_input_as_handled()
		_current_person = null
		remove_smog()


func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.pressed:
			if _current_person != null and _current_person.get_node("Devil") != null:
				return
			else:
				_process_persons()
